using MySqlConnector;

// ANSLUTNING TILL DATABASEN
// Server=123.0.4.5;Port=3306;Database=shoppy;User ID=root;Password=rootroot;UseAffectedRows=false;

// känslig information som inte ska vara här. Egentligen.
string connectionString = "Server=localhost;Database=HolidayMaker;User ID=root;Password=kurslosenord;UseAffectedRows=false;";

await using var connection = new MySqlConnection(connectionString);
await connection.OpenAsync();

// REPOSITORY (klass med databas-queries)
var repository = new BookingRepository(connection);


// ANVÄNDER repository för att hämta data

// 1. READ: hämta alla produkter som en lista.

// 2. CREATE: skapa en kund och ta emot databasens nya id.
int newId = await repository.CreateCustomerAsync("Laban Lindqvist", "Östergatan 8, 211 34 Malmö, Sweden", "laban.lindqvist@example.se", "+46 70-174 06 17");
Console.WriteLine($"Ny kund med id: {newId}");

// 3. READ: hämta den nya kunden som ett enstaka objekt.
Customer? created = await repository.GetProductAsync(newId);
Console.WriteLine(created is null ? "Kunden saknas." : created.ToString());