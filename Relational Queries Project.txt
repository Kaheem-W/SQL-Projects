/* Create table about the people and what they do here */
create table famous_people(id integer primary key, full_name varchar (MAX));
insert into famous_people(id, full_name)
    values(1, 'kanye west');
insert into famous_people(id, full_name)
    values(2, 'kim kardashian');
insert into famous_people(id, full_name)
    values(3, 'harrison ford');
insert into famous_people(id, full_name)
    values(4, 'rhea perlman');
insert into famous_people(id, full_name)
    values(5, 'percy jackson');
insert into famous_people(id, full_name)
    values(6, 'danny devito');
insert into famous_people(id, full_name)
    values(7, 'marshall mathers');
insert into famous_people(id, full_name)
    values(8, 'harry potter');
insert into famous_people(id, full_name)
    values(9, 'calista flockart');
insert into famous_people(id, full_name)
    values(10, 'michael jackson');
insert into famous_people(id, full_name)
    values(11, 'frodo baggins');


/* first relate table for artist and songs they song*/
create table songs(id integer primary key, song_name varchar (MAX), person_id integer);
insert into songs(id, song_name, person_id)
    values(1, 'bad guy', 7);
insert into songs(id, song_name, person_id)
    values(2, 'smooth criminal', 10);
insert into songs(id, song_name, person_id)
    values(3, 'dark fantasy', 1);
insert into songs(id, song_name, person_id)
    values(4, 'beat it', 10);
insert into songs(id, song_name, person_id)
    values(5, 'survival', 7);
insert into songs(id, song_name, person_id)
    values(6, 'not afraid', 7);
insert into songs(id, song_name, person_id)
    values(7, 'ultralight beam', 1);
    
    
/*2nd relate table for relationship status of famous people*/
create table relationship(id integer primary key, relationship_status varchar (MAX), person1_id integer, person2_id integer);
insert into relationship(id, relationship_status, person1_id, person2_id)
    values(1, 'married', 3, 9);
insert into relationship(id, relationship_status, person1_id, person2_id)
    values(2, 'divorce', 1, 2);
insert into relationship(id, relationship_status, person1_id, person2_id)
    values(3, 'married', 4, 6);
    
    
/*3rd table for books fictional characters are from*/
create table books(id integer primary key, book_title varchar (MAX), character_id integer);
insert into books(id, book_title, character_id)
    values(1, 'the hobbit', 11);
insert into books(id, book_title, character_id)
    values(2, 'the two towers', 11);
insert into books(id, book_title, character_id)
    values(3, 'the lightning thief', 5);
insert into books(id, book_title, character_id)
    values(4, 'harry potter and the goblet of fire', 8);
insert into books(id, book_title, character_id)
    values(5, 'the sea of monsters', 5);
insert into books(id, book_title, character_id)
    values(6, 'harry potter and the deathly hallows', 8);
insert into books(id, book_title, character_id)
    values(7, 'the last olympian', 5);
    
    
/* 4th is movies actors are in*/
create table movies(id integer primary key, movie_title varchar (MAX), person_id integer);
insert into movies(id, movie_title, person_id)
    values(1, 'batman returns', 6);
insert into movies(id, movie_title, person_id)
    values(2, 'indiana jones and the raiders of the lost ark', 3);
insert into movies(id, movie_title, person_id)
    values(3, 'indiana jones and the last crusade', 3);
insert into movies(id, movie_title, person_id)
    values(4, 'matilda', 6);
insert into movies(id, movie_title, person_id)
    values(5, 'ruthless people', 6);


/*Now that all tables are complete, time to join the tables*/

/*1st table is artists and songs joined with */
select famous_people.full_name, songs.song_name
    from famous_people
    join songs
    on famous_people.id = songs.person_id;

/*2nd is relationship status by combining multiple joins*/
select a.full_name as male, b.full_name as female, relationship_status from relationship
    join famous_people a
    on person1_id = a.id
    join famous_people b
    on person2_id = b.id;
/*3rd table is characters from famous book series*/

select famous_people.full_name, books.book_title
    from famous_people
    join books
    on famous_people.id = books.character_id;
    
