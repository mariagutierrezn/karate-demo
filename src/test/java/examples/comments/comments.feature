Feature: Pruebas CRUD sobre el endpoint de comentarios

  Background:
    * url 'https://jsonplaceholder.typicode.com/'

  Scenario: Obtener un comentario y validar sus datos
    Given path 'comments',1
    When method get
    Then status 200
    And match response contains { postId: '#number', name: '#string', email: '#string', body: '#string' }

  Scenario: Obtener lista de todos los comentarios
    Given path 'comments'
    When method get
    Then status 200
    And match response[0] contains { id: '#number', name: '#string', email: '#string', body: '#string' }

  Scenario: Crear un nuevo comentario
    * def new_comment =
      """
      {
        "postId": 1,
        "name": "Comentario de prueba",
        "email": "test@ejemplo.com",
        "body": "Este es un comentario de prueba"
      }
      """
    Given path 'comments'
    And request new_comment
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.name == 'Comentario de prueba'
    And match response.email == 'test@ejemplo.com'

  Scenario: Actualizar un comentario completo
    * def updated_comment =
      """
      {
        "id": 1,
        "postId": 1,
        "name": "Nombre actualizado",
        "email": "actualizado@ejemplo.com",
        "body": "Comentario actualizado"
      }
      """
    Given path 'comments', 1
    And request updated_comment
    When method put
    Then status 200
    And match response.id == 1
    And match response.name == 'Nombre actualizado'
    And match response.email == 'actualizado@ejemplo.com'

  Scenario: Actualizar parcialmente un comentario
    Given path 'comments', 1
    And request { "name": "Nombre parcialmente actualizado" }
    When method patch
    Then status 200
    And match response.name == 'Nombre parcialmente actualizado'

  Scenario Outline: Crear un comentario con diferentes datos usando Scenario Outline
    * def new_comment =
      """
      {
        "postId": <postId>,
        "name": "<name>",
        "email": "<email>",
        "body": "<body>"
      }
      """
    Given path 'comments'
    And request new_comment
    When method post
    Then status 201
    And match response.name == "<name>"
    And match response.email == "<email>"
    And match response.body == "<body>"

    Examples:
      | postId | name        | email            | body               |
      |      1 | Prueba Uno  | uno@ejemplo.com  | Primer comentario  |
      |      2 | Prueba Dos  | dos@ejemplo.com  | Segundo comentario |
      |      3 | Prueba Tres | tres@ejemplo.com | Tercer comentario  |

  Scenario: Eliminar un comentario
    Given path 'comments', 1
    When method delete
    Then status 200
    And match response == {}
