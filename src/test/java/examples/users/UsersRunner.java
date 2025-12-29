package examples.users;

import com.intuit.karate.junit5.Karate;

public class UsersRunner {

    @Karate.Test
    Karate testUsers() {
        // Ejecuta el archivo 'users.feature' que está en el mismo paquete
        return Karate.run("users").relativeTo(getClass());
    }

}
