public class HerokuParser {

	public Integer quantity { get; set; }
	public String name { get; set; }
	public Integer maintenanceperiod { get; set; }
	public Integer lifespan { get; set; }
	public Integer cost { get; set; }
	public String sku { get; set; }

	public static List<HerokuParser> parse(String json) {
		return (List<HerokuParser>) System.JSON.deserialize(json, List<HerokuParser>.class);
	}
}
