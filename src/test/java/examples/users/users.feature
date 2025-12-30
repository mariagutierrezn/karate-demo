Feature: Demostración completa de Karate Framework - Métodos HTTP

  Background:
    * url 'https://jsonplaceholder.typicode.com'

  Scenario: GET - Obtener un usuario y validar sus datos
    Given path 'users', '1'
    When method get
    Then status 200
    And match response.name == 'Leanne Graham'
    And match response.email == 'Sincere@april.biz'
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
    And match response == '#[10]'
    And match response[0] contains { id: '#number', name: '#string', email: '#string' }

  Scenario: POST - Crear un nuevo usuario
    Given path 'users'
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

    When method post
    Then status 201
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

  Scenario: PUT - Actualizar un usuario completo
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

  Scenario: PATCH - Actualizar parcialmente un usuario
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
    And match each response contains { userId: 1 }

  Scenario: Validar headers de respuesta
    Given path 'users', '1'
    When method get
    Then status 200
    And match header Content-Type contains 'application/json'
