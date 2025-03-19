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

                return result > 0 ? Ok(new { message = "Producto registrado correctamente."}) : BadRequest(new { message = "Error al registrar el producto." });
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
                cmd.CommandType = CommandType.x;
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

                    return Ok(new { message = "Movimiento registrado correctamente." });
                }
                catch (Exception ex)
                {
                    return BadRequest(new { message= $"Error en SQL: {ex.Message}" });
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

    [HttpGet("producto")]
    public IActionResult ObtenerProductos()
    {
        List<Producto> productos = new List<Producto>();

        using (SqlConnection conn = new SqlConnection(_connectionString))
        {
            string query = "SELECT id, sku, descripcion, fecha_vencimiento FROM Producto";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        productos.Add(new Producto
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("id")), 
                            SKU = reader["sku"] != DBNull.Value ? reader["sku"].ToString()! : "", 
                            Descripcion = reader["descripcion"] != DBNull.Value ? reader["descripcion"].ToString()! : "",
                            FechaVencimiento = reader.GetDateTime(reader.GetOrdinal("fecha_vencimiento")) 
                        });
                    }
                }
                conn.Close();
            }
        }

        return Ok(productos);
    }


    [HttpGet("movimiento")]
    public IActionResult ObtenerMovimientos()
    {
        List<object> movimientos = new List<object>();

        using (SqlConnection conn = new SqlConnection(_connectionString))
        {
            string query = @"
            SELECT m.id, t.nombre AS tipoMovimiento, p.sku AS producto, 
                   b1.nombre AS bodegaOrigen, b2.nombre AS bodegaDestino, 
                   m.cantidad, m.fecha 
            FROM Movimiento m
            INNER JOIN TipoMovimiento t ON m.tipo_movimiento_id = t.id
            INNER JOIN Producto p ON m.producto_id = p.id
            LEFT JOIN Bodega b1 ON m.bodega_origen_id = b1.id
            LEFT JOIN Bodega b2 ON m.bodega_destino_id = b2.id
            ORDER BY m.fecha DESC";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        movimientos.Add(new
                        {
                            Id = reader["id"],
                            TipoMovimiento = reader["tipoMovimiento"].ToString(),
                            Producto = reader["producto"].ToString(),
                            BodegaOrigen = reader["bodegaOrigen"] != DBNull.Value ? reader["bodegaOrigen"].ToString() : "N/A",
                            BodegaDestino = reader["bodegaDestino"] != DBNull.Value ? reader["bodegaDestino"].ToString() : "N/A",
                            Cantidad = Convert.ToInt32(reader["cantidad"]),
                            Fecha = Convert.ToDateTime(reader["fecha"]).ToString("yyyy-MM-dd HH:mm:ss")
                        });
                    }
                }
                conn.Close();
            }
        }

        return Ok(movimientos);
    }

}
