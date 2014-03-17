select * from qwyz_items;
select * from users;
select * from qwyzs;
select * from votes;
select chosen_item_id, count(*) as count from votes where qwyz_id = 2  group by chosen_item_id order by count desc;
