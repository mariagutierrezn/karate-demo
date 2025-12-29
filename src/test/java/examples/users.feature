Feature: Demostración completa de Karate Framework - Métodos HTTP

  Background:
    # Esto se ejecuta antes de cada escenario
    * url 'https://jsonplaceholder.typicode.com'

  # ==================== GET ====================
  Scenario: GET - Obtener un usuario y validar sus datos
    # 1. Definir la ruta (endpoint)
    Given path 'users', '1'

    # 2. Ejecutar la acción HTTP
    When method get

    # 3. Validaciones básicas (Status Code)
    Then status 200

    # 4. Validar datos específicos (fácil de leer)
    And match response.name == 'Leanne Graham'
    And match response.email == 'Sincere@april.biz'

    # 5. LA MAGIA: Validar la estructura (Schema Validation)
    # Aquí validamos que el ID sea un número y el city sea un texto,
    # sin importar qué valor tengan.
    And match response.address ==
      """
      {
        street: '#string',
        suite: '#string',
        city: '#string',
        zipcode: '#string',
        geo: { lat: '#string', lng: '#string' }
      }
      """

  Scenario: GET - Obtener lista de todos los usuarios
    Given path 'users'
    When method get
    Then status 200
    # Validar que la respuesta es un array
    And match response == '#[10]'
    # Validar que el primer elemento tiene la estructura esperada
    And match response[0] contains { id: '#number', name: '#string', email: '#string' }

  # ==================== POST ====================
  Scenario: POST - Crear un nuevo usuario
    # 1. Definir el endpoint
    Given path 'users'

    # 2. Preparar el cuerpo de la petición (request body)
    And request
      """
      {
        "name": "María Gutiérrez",
        "username": "mariag",
        "email": "maria.gutierrez@ejemplo.com",
        "address": {
          "street": "Calle Principal 123",
          "city": "Ciudad de México",
          "zipcode": "12345"
        }
      }
      """

    # 3. Ejecutar el método POST
    When method post

    # 4. Validar que se creó correctamente (código 201)
    Then status 201

    # 5. Validar que la respuesta contiene el nuevo ID
    And match response.id == '#number'
    And match response.name == 'María Gutiérrez'
    And match response.email == 'maria.gutierrez@ejemplo.com'

  Scenario: POST - Crear un nuevo post
    Given path 'posts'
    And request
      """
      {
        "title": "Mi primer post con Karate",
        "body": "Este es el contenido del post para demostrar POST",
        "userId": 1
      }
      """
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.title == 'Mi primer post con Karate'
    And match response.userId == 1

  # ==================== PUT ====================
  Scenario: PUT - Actualizar un usuario completo
    # PUT reemplaza todo el recurso
    Given path 'users', '1'
    And request
      """
      {
        "id": 1,
        "name": "Leanne Graham Actualizada",
        "username": "Bret",
        "email": "leanne.actualizada@ejemplo.com",
        "address": {
          "street": "Nueva Calle 456",
          "city": "Nueva Ciudad",
          "zipcode": "67890"
        }
      }
      """
    When method put
    Then status 200
    And match response.id == 1
    And match response.name == 'Leanne Graham Actualizada'
    And match response.email == 'leanne.actualizada@ejemplo.com'

  Scenario: PUT - Actualizar un post completo
    Given path 'posts', '1'
    And request
      """
      {
        "id": 1,
        "title": "Título actualizado con PUT",
        "body": "Contenido completamente actualizado",
        "userId": 1
      }
      """
    When method put
    Then status 200
    And match response.id == 1
    And match response.title == 'Título actualizado con PUT'

  # ==================== PATCH ====================
  Scenario: PATCH - Actualizar parcialmente un usuario
    # PATCH actualiza solo los campos enviados
    Given path 'users', '1'
    And request
      """
      {
        "email": "email.parcialmente.actualizado@ejemplo.com"
      }
      """
    When method patch
    Then status 200
    And match response.email == 'email.parcialmente.actualizado@ejemplo.com'
    # Otros campos deberían permanecer sin cambios

  # ==================== DELETE ====================
  Scenario: DELETE - Eliminar un usuario
    Given path 'users', '1'
    When method delete
    Then status 200
    # JSONPlaceholder retorna un objeto vacío al eliminar
    And match response == {}

  Scenario: DELETE - Eliminar un post
    Given path 'posts', '1'
    When method delete
    Then status 200
    And match response == {}

  # ==================== ESCENARIOS ADICIONALES ====================
  Scenario: Validar manejo de errores - Usuario no encontrado
    Given path 'users', '999999'
    When method get
    Then status 404

  Scenario: GET con query parameters
    Given path 'posts'
    # Filtrar posts por userId
    And param userId = 1
    When method get
    Then status 200
    # Validar que todos los posts pertenecen al usuario 1
    And match each response contains { userId: 1 }

  Scenario: Validar headers de respuesta
    Given path 'users', '1'
    When method get
    Then status 200
    # Validar headers comunes
    And match header Content-Type contains 'application/json'
