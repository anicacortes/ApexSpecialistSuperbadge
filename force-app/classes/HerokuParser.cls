public class HerokuParser {

	public String x_id { get; set; }
	public Boolean replacement { get; set; }
	public Integer quantity { get; set; }
	public String name { get; set; }
	public Integer maintenanceperiod { get; set; }
	public Integer lifespan { get; set; }
	public Integer cost { get; set; }
	public String sku { get; set; }

	public static List<HerokuParser> parse(String json) {
		return (List<HerokuParser>) System.JSON.deserialize(json.replaceAll('_id','x_id'), List<HerokuParser>.class);
	}
}
