select * from qwyz_items;
select * from users;
select * from qwyzs;
select * from votes where qwyz_id = 5;
select chosen_item_id, count(*) as count from votes where qwyz_id = 2  group by chosen_item_id order by count desc;
select q.id, u.name from users u, qwyzs q where q.user_id = u.id and q.id in (1, 2, 3, 4, 5, 6, 7);
SELECT chosen_item_id, count(*) as vote_count FROM "votes" WHERE "votes"."qwyz_id" = 1 GROUP BY chosen_item_id;
SELECT COUNT(*) FROM "votes" WHERE "votes"."qwyz_id" = 1 AND "votes"."voter_user_id" = 2;
delete from votes;