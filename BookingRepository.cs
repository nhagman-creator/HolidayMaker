using MySqlConnector;

public class BookingRepository(MySqlConnection connection)
{
    //Create a new customer
    public async Task<int> CreateCustomerAsync(string name, string address, string email, string phone)
    {
        await using var command = new MySqlCommand(
            "INSERT INTO customers (name, address, email, phone) VALUES (@name, @address, @email, @phone);", connection);
        command.Parameters.AddWithValue("@name", name);
        command.Parameters.AddWithValue("@address", address);
        command.Parameters.AddWithValue("@email", email);
        command.Parameters.AddWithValue("@phone", phone);
        await command.PrepareAsync();
        await command.ExecuteNonQueryAsync();
        return checked((int)command.LastInsertedId);
    }
    
    // READ: en rad → ett objekt, eller null när id saknas.
    public async Task<Customer?> GetProductAsync(int id)
    {
        await using var command = new MySqlCommand(
            "SELECT id, name, address, email, phone FROM customers WHERE id = @id;", connection);
        command.Parameters.AddWithValue("@id", id);

        await command.PrepareAsync();
        await using var reader = await command.ExecuteReaderAsync();

        if (await reader.ReadAsync())
        {
            return new Customer(
                reader.GetInt32("id"),
                reader.GetString("name"),
                reader.GetString("address"),
                reader.GetString("email"),
                reader.GetString("phone"));
        }
        return null;
    }

}