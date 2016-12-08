CREATE TABLE IF NOT EXISTS main.wineries(
    id integer primary key autoincrement not null,
    name varchar,
    country varchar,
    region varchar,
    volume float,
    uom varchar
)

CREATE TABLE IF NOT EXISTS main.wine(

    id integer primary key autoincrement not null,
    name varchar,
    rating integer,
    image blob,
    producer_id integer foreign key references wineries(id)
)


CREATE VIEW IS NOT EXISTS main.winelist
AS select wine.name, wine.rating, ws.name, ws.country, ws.region from wine inner join wineries ws ON
wine.producer_id = ws.id