using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using InventarioAPI.Models;

[Route("api/[controller]")]
[ApiController]
public class InventarioController : ControllerBase
{
    private readonly string _connectionString;

    public InventarioController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    // Registrar un nuevo producto
    [HttpPost("producto")]
    public IActionResult RegistrarProducto([FromBody] Producto producto)
    {
        using (SqlConnection conn = new SqlConnection(_connectionString))
        {
            string query = "INSERT INTO Producto (sku, descripcion, fecha_vencimiento) VALUES (@sku, @descripcion, @fecha_vencimiento)";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@sku", producto.SKU);
                cmd.Parameters.AddWithValue("@descripcion", producto.Descripcion);
                cmd.Parameters.AddWithValue("@fecha_vencimiento", producto.FechaVencimiento);

                conn.Open();
                int result = cmd.ExecuteNonQuery();
                conn.Close();

                return result > 0 ? Ok("Producto registrado correctamente.") : BadRequest("Error al registrar el producto.");
            }
        }
    }

    // Registrar movimientos de entrada y salida
    [HttpPost("movimiento")]
    public IActionResult RegistrarMovimiento([FromBody] Movimiento movimiento)
    {
        using (SqlConnection conn = new SqlConnection(_connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("RegistrarMovimiento", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@tipo_movimiento_id", movimiento.TipoMovimientoId);
                cmd.Parameters.AddWithValue("@producto_id", movimiento.ProductoId);
                cmd.Parameters.AddWithValue("@bodega_origen_id", (object)movimiento.BodegaOrigenId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@bodega_destino_id", (object)movimiento.BodegaDestinoId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@cantidad", movimiento.Cantidad);

                try
                {
                    conn.Open();
                    int result = cmd.ExecuteNonQuery(); // Este puede ser 0 si no devuelve filas afectadas
                    conn.Close();

                    return Ok("Movimiento registrado correctamente.");
                }
                catch (Exception ex)
                {
                    return BadRequest($"Error en SQL: {ex.Message}");
                }

            }

        }
    }

    // Consultar saldo de existencias por producto
    [HttpGet("existencias/{productoId}")]
    public IActionResult ConsultarExistencias(int productoId)
    {
        using (SqlConnection conn = new SqlConnection(_connectionString))
        {
            string query = "SELECT b.nombre, e.cantidad FROM Existencia e INNER JOIN Bodega b ON e.bodega_id = b.id WHERE e.producto_id = @productoId";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@productoId", productoId);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    List<object> existencias = new List<object>();

                    while (reader.Read())
                    {
                        existencias.Add(new { Bodega = reader["nombre"].ToString(), Cantidad = Convert.ToInt32(reader["cantidad"]) });
                    }
                    conn.Close();

                    return Ok(existencias);
                }
            }
        }
    }
}
