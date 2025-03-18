namespace InventarioAPI.Models
{
    public class Movimiento
    {
        public int TipoMovimientoId { get; set; }
        public int ProductoId { get; set; }
        public int? BodegaOrigenId { get; set; }
        public int? BodegaDestinoId { get; set; }
        public int Cantidad { get; set; }
    }
}