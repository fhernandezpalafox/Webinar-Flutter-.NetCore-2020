using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MySql.Data.MySqlClient;
using Dapper;
using Microsoft.AspNetCore.Cors;
using System.Net.Http;
using Newtonsoft.Json;

namespace ApiRest.Controllers
{
  
    [EnableCors("MyPolicy")]
    [ApiController]
    [Route("api/v1/[controller]")]
    public class DatosController : ControllerBase
    {
        private string _connectionString = "Server=localhost;Database=bdlugares;Uid=root;Pwd=;";


        [HttpGet("lugares")]
        public IActionResult GetLugares()
        {

            MySqlConnection connection = new MySqlConnection(_connectionString);

            try
            {
                var sql = "SELECT id,nombre,descripcion,direccion,telefono,website,imagen_nombre,importancia,latitud,longitud,title,reaction,rating FROM lugares";
                var result = connection.Query<lugares>(sql).ToList();

                if (result.Count == 0)
                {
                    return NoContent();
                }

                var json = JsonConvert.SerializeObject(result);

                return Ok(json);

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return NotFound();
            }

        }


        [HttpGet("lugaresv2")]
        public IActionResult GetLugaresv2()
        {

            MySqlConnection connection = new MySqlConnection(_connectionString);

            try
            {
                var dt = new DataTable();

                var sql = "SELECT id,nombre,descripcion,direccion,telefono,website,imagen_nombre,importancia,latitud,longitud,title,reaction,rating FROM lugares";

                var cmd = new MySqlCommand(sql, connection);

                connection.Open();

                var da = new MySqlDataAdapter(cmd);

                da.Fill(dt);

                connection.Close();

                var lista = new List<lugares>();
                


                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    var lugar = new lugares();

                    lugar.id = int.Parse((dt.Rows[i]["id"]).ToString());
                    lugar.nombre = (dt.Rows[i]["nombre"]).ToString();
                    lugar.descripcion = (dt.Rows[i]["descripcion"]).ToString();
                    lugar.direccion = (dt.Rows[i]["direccion"]).ToString();
                    lugar.telefono = (dt.Rows[i]["telefono"]).ToString();
                    lugar.website = (dt.Rows[i]["website"]).ToString();
                    lugar.imagen_nombre = (dt.Rows[i]["imagen_nombre"]).ToString();
                    lugar.importancia = (dt.Rows[i]["importancia"]).ToString();
                    lugar.latitud = ((double)dt.Rows[i]["latitud"]);
                    lugar.longitud = ((double)dt.Rows[i]["longitud"]);
                    lugar.title = (dt.Rows[i]["title"]).ToString();
                    lugar.reaction  = (dt.Rows[i]["reaction"]).ToString();
                    lugar.rating = int.Parse((dt.Rows[i]["rating"]).ToString());

                    lista.Add(lugar);

                }


                if (lista.Count == 0)
                {
                    return NoContent();
                }

                var json = JsonConvert.SerializeObject(lista);

                return Ok(json);

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return NotFound();
            }

        }

    }

    public class lugares {
       
        public int id   { get; set; }
        public String nombre  { get; set; }
        public String descripcion  { get; set; }
        public String direccion  { get; set; }
        public String telefono  { get; set; }
        public String website  { get; set; }
        public String imagen_nombre  { get; set; }
        public String importancia  { get; set; }
        public double latitud  { get; set; }
        public double longitud  { get; set; }
        public String title  { get; set; }
        public String reaction  { get; set; }
        public int rating {get; set;}

    }
}