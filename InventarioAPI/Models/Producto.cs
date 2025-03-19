namespace InventarioAPI.Models
{
	public class Producto
	{
		public int Id { get; set; }
		public string SKU { get; set; }
		public string Descripcion { get; set; }
		public DateTime FechaVencimiento { get; set; }
	}
}
