-- Primera Consulta
SELECT DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;

-- Segunda Consulta
SELECT Posts.Title, Users.DisplayName
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL; 

-- Tercera Consulta
SELECT u.DisplayName, AVG(p.Score) AS AverageScore
from Posts p
INNER JOIN Users u
ON p.OwnerUserId = u.Id
GROUP BY u.DisplayName
Order BY AverageScore

-- Cuarta Consulta
SELECT u.DisplayName
FROM
   Users u
WHERE 
    u.Id IN (
        SELECT 
            c.UserId
        FROM 
            Comments c
        GROUP BY 
            c.UserId
        HAVING 
            COUNT(c.UserId) > 100
    )
ORDER BY 
    u.DisplayName;

-- Quinta Consulta
Update Users
SET Location = 'Desconocido'
WHERE Location IS NULL;
PRINT 'Los valores nulos se han actualizado a "Desconocido"';


-- Sexta Consulta
DECLARE @ComentariosRealizados INT;

DELETE FROM Comments 
WHERE UserId IN (SELECT Id FROM Users WHERE Reputation <100);

SET @ComentariosRealizados = @@ROWCOUNT

PRINT 'Los comentarios eliminados fueron: ' + CAST(@ComentariosRealizados AS VARCHAR);

-- Septima Consulta
WITH UserPosts AS (
    SELECT OwnerUserId, COUNT(DISTINCT Id) AS TotalPosts
    FROM Posts
    GROUP BY OwnerUserId
),
--Crear una subconsulta que agregue el número total de comentarios únicos hechos por cada usuario.
UserComments AS (
    SELECT UserId, COUNT(DISTINCT Id) AS TotalComments
    FROM Comments
    GROUP BY UserId
),
-- Crear una subconsulta que agregue el número total de insignias únicas obtenidas por cada usuario.
UserBadges AS (
    SELECT UserId, COUNT(DISTINCT Id) AS TotalBadges
    FROM Badges
    GROUP BY UserId
)
--Seleccionar los 100 primeros usuarios junto con sus totales de publicaciones, comentarios e insignias, ordenados por nombre de usuario.
SELECT TOP 100
    Users.DisplayName, 
    ISNULL(UserPosts.TotalPosts, 0) AS TotalPosts,
    ISNULL(UserComments.TotalComments, 0) AS TotalComments,
    ISNULL(UserBadges.TotalBadges, 0) AS TotalBadges
FROM 
    Users
LEFT JOIN 
    UserPosts ON UserPosts.OwnerUserId = Users.Id
LEFT JOIN 
    UserComments ON UserComments.UserId = Users.Id
LEFT JOIN 
    UserBadges ON UserBadges.UserId = Users.Id
ORDER BY 
    Users.DisplayName;



-- Octava Consulta
SELECT TOP (10) p.Score, p.title FROM Posts p
ORDER BY Score DESC;


-- Novena Consulta
SELECT TOP(5) c.CreationDate, c.Text FROM Comments c
ORDER BY CreationDate DESC;