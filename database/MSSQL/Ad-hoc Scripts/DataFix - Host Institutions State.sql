-- reexport lu_city csv

select d.count, l.* from lu_city l
join (select Name, country,count(*) as count from lu_city group by name, country having count(*) > 1) d on l.name=d.name and l.country=d.country
order by l.name, l.state


select * from institution WHERE city='Camperdown' and country='AU' 
update institution set STate = 'NSW' WHERE city='Camperdown' and country='AU' and state is null
delete lu_city  WHERE name='Camperdown' and country='AU' and state is null 

select * from institution WHERE city='Glasgow' and country='UK' 
update institution set STate = 'SCO' WHERE city='Glasgow' and country='UK' and state is null
delete lu_city  WHERE name='Glasgow' and country='UK' and state is null 

select * from institution WHERE city='London' and country='UK' 
update institution set STate = 'ENG' WHERE city='London' and country='UK' and state is null
delete lu_city  WHERE name='London' and country='UK' and state is null 
update lu_city set latitude=51.514125, longitude=-0.093689 where name='london' and state='ENG'

select * from institution WHERE city='Cambridge' and country='UK' 
update institution set STate = 'ENG' WHERE city='Cambridge' and country='UK' and state is null
delete lu_city  WHERE name='Cambridge' and country='UK' and state is null 

select * from institution WHERE city='Carlton' and country='AU' 
update institution set STate = 'VIC' WHERE city='Carlton' and country='AU' and state is null
delete lu_city  WHERE name='Carlton' and country='AU' and state is null 

select * from institution WHERE city='Charlottetown' and country='CA' 
update institution set STate = 'PE' WHERE city='Charlottetown' and country='CA' and state is null
delete lu_city  WHERE name='Charlottetown' and country='CA' and state is null 

select * from institution WHERE city='Darlinghurst' and country='AU' 
update institution set STate = 'NSW' WHERE city='Darlinghurst' and country='AU' and state is null
delete lu_city  WHERE name='Darlinghurst' and country='AU' and state is null 

select * from institution WHERE city='Edmonton' and country='CA' 
update institution set STate = 'AB' WHERE city='Edmonton' and country='CA' and state is null
delete lu_city  WHERE name='Edmonton' and country='CA' and state is null 

select * from institution WHERE city='Surrey' and country='CA' 
update institution set STate = 'BC' WHERE city='Surrey' and country='CA' and state is null
delete lu_city  WHERE name='Surrey' and country='CA' and state is null 

select * from institution WHERE city='Sydney' and country='AU' 
update institution set STate = 'NSW' WHERE city='Sydney' and country='AU' and state is null
delete lu_city  WHERE name='Sydney' and country='AU' and state is null 

select * from institution WHERE city='Fredericton' and country='CA' 
update institution set STate = 'NB' WHERE city='Fredericton' and country='CA' and state is null
delete lu_city  WHERE name='Fredericton' and country='CA' and state is null 

select * from institution WHERE city='Fukuoka' and country='JP' 
update institution set STate = '40' WHERE city='Fukuoka' and country='JP' and state is null
delete lu_city  WHERE name='Fukuoka' and country='JP' and state is null 

select * from institution WHERE city='Greater Sudbury' and country='CA' 
update institution set STate = 'ON' WHERE city='Greater Sudbury' and country='CA' and state is null
delete lu_city  WHERE name='Greater Sudbury' and country='CA' and state is null 

select * from institution WHERE city='Gold Coast' and country='AU' 
update institution set STate = 'QLD' WHERE city='Gold Coast' and country='AU' and state is null
delete lu_city  WHERE name='Gold Coast' and country='AU' and state is null 

select * from institution WHERE city='Guangzhou' and country='CN' 
update institution set STate = 'Guangdong' WHERE city='Guangzhou' and country='CN' and state is null
delete lu_city  WHERE name='Guangzhou' and country='CN' and state is null 

select * from institution WHERE city='Halifax' and country='CA' 
update institution set STate = 'NS' WHERE city='Halifax' and country='CA' and state is null
delete lu_city  WHERE name='Halifax' and country='CA' and state is null 

select * from institution WHERE city='Hamburg' and country='DE' 
update institution set STate = 'HH' WHERE city='Hamburg' and country='DE' and state is null
delete lu_city  WHERE name='Hamburg' and country='DE' and state is null 

select * from institution WHERE city='Guadalajara' and country='MX' 
update institution set STate = 'JA' WHERE city='Guadalajara' and country='MX' and state is null
delete lu_city  WHERE name='Guadalajara' and country='MX' and state is null 

select * from institution WHERE city='Heidelberg' and country='AU' 
update institution set STate = 'VIC' WHERE city='Heidelberg' and country='AU' and state is null
delete lu_city  WHERE name='Heidelberg' and country='AU' and state is null 

select * from institution WHERE city='Hobart' and country='AU' 
update institution set STate = 'TAS' WHERE city='Hobart' and country='AU' and state is null
delete lu_city  WHERE name='Hobart' and country='AU' and state is null 

select * from institution WHERE city='Hamilton' and country='CA' 
update institution set STate = 'ON' WHERE city='Hamilton' and country='CA' and state is null
delete lu_city  WHERE name='Hamilton' and country='CA' and state is null 

select * from institution WHERE city='Kingston' and country='CA' 
update institution set STate = 'ON' WHERE city='Kingston' and country='CA' and state is null
delete lu_city  WHERE name='Kingston' and country='CA' and state is null 

select * from institution WHERE city='Laval' and country='CA' 
update institution set STate = 'QC' WHERE city='Laval' and country='CA' and state is null
delete lu_city  WHERE name='Laval' and country='CA' and state is null 

select * from institution WHERE city='Kyoto' and country='JP' 
update institution set STate = '26' WHERE city='Kyoto' and country='JP' and state is null
delete lu_city  WHERE name='Kyoto' and country='JP' and state is null 

select * from institution WHERE city='Lethbridge' and country='CA' 
update institution set STate = 'AB' WHERE city='Lethbridge' and country='CA' and state is null
delete lu_city  WHERE name='Lethbridge' and country='CA' and state is null 

select * from institution WHERE city='London' and country='CA' 
update institution set STate = 'ON' WHERE city='London' and country='CA' and state is null
delete lu_city  WHERE name='London' and country='CA' and state is null 

select * from institution WHERE city='Maebashi' and country='JP' 
update institution set STate = '10' WHERE city='Maebashi' and country='JP' and state is null
delete lu_city  WHERE name='Maebashi' and country='JP' and state is null 

select * from institution WHERE city='Manchester' and country='UK' 
update institution set STate = 'ENG' WHERE city='Manchester' and country='UK' and state is null
delete lu_city  WHERE name='Manchester' and country='UK' and state is null 

select * from institution WHERE city='Markham' and country='CA' 
update institution set STate = 'ON' WHERE city='Markham' and country='CA' and state is null
delete lu_city  WHERE name='Markham' and country='CA' and state is null 

select * from institution WHERE city='Matsuyama' and country='JP' 
update institution set STate = '38' WHERE city='Matsuyama' and country='JP' and state is null
delete lu_city  WHERE name='Matsuyama' and country='JP' and state is null 

select * from institution WHERE city='Melbourne' and country='AU' 
update institution set STate = 'VIC' WHERE city='Melbourne' and country='AU' and state is null
delete lu_city  WHERE name='Melbourne' and country='AU' and state is null 

select * from institution WHERE city='Mexico City' and country='MX' 
update institution set STate = 'MX' WHERE city='Mexico City' and country='MX' and state is null
delete lu_city  WHERE name='Mexico City' and country='MX' and state is null 

select * from institution WHERE city='Nagoya' and country='JP' 
update institution set STate = '23' WHERE city='Nagoya' and country='JP' and state is null
delete lu_city  WHERE name='Nagoya' and country='JP' and state is null 

select * from institution WHERE city='Nagoya' and country='JP' 
update institution set STate = '23' WHERE city='Nagoya' and country='JP' and state is null
delete lu_city  WHERE name='Nagoya' and country='JP' and state is null 

select * from institution WHERE city='Moncton' and country='CA' 
update institution set STate = 'NB' WHERE city='Moncton' and country='CA' and state is null
delete lu_city  WHERE name='Moncton' and country='CA' and state is null 

select * from institution WHERE city='Montréal' and country='CA' 
update institution set STate = 'QC' WHERE city='Montréal' and country='CA' and state is null
delete lu_city  WHERE name='Montréal' and country='CA' and state is null 

select * from institution WHERE city='Newcastle' and country='AU' 
update institution set STate = 'NSW' WHERE city='Newcastle' and country='AU' and state is null
delete lu_city  WHERE name='Newcastle' and country='AU' and state is null 

select * from institution WHERE city='Newmarket' and country='CA' 
update institution set STate = 'ON' WHERE city='Newmarket' and country='CA' and state is null
delete lu_city  WHERE name='Newmarket' and country='CA' and state is null 

select * from institution WHERE city='Norwich' and country='UK' 
update institution set STate = 'ENG' WHERE city='Norwich' and country='UK' and state is null
delete lu_city  WHERE name='Norwich' and country='UK' and state is null 

select * from institution WHERE city='Nottingham' and country='UK' 
update institution set STate = 'ENG' WHERE city='Nottingham' and country='UK' and state is null
delete lu_city  WHERE name='Nottingham' and country='UK' and state is null 

select * from institution WHERE city='Okayama' and country='JP' 
update institution set STate = '33' WHERE city='Okayama' and country='JP' and state is null
delete lu_city  WHERE name='Okayama' and country='JP' and state is null 

select * from institution WHERE city='Oshawa' and country='CA' 
update institution set STate = 'ON' WHERE city='Oshawa' and country='CA' and state is null
delete lu_city  WHERE name='Oshawa' and country='CA' and state is null 

select * from institution WHERE city='Ottawa' and country='CA' 
update institution set STate = 'ON' WHERE city='Ottawa' and country='CA' and state is null
delete lu_city  WHERE name='Ottawa' and country='CA' and state is null 

select * from institution WHERE city='Oxford' and country='UK' 
update institution set STate = 'ENG' WHERE city='Oxford' and country='UK' and state is null
delete lu_city  WHERE name='Oxford' and country='UK' and state is null 

select * from institution WHERE city='Ponce' and country='PR' 
update institution set STate = 'PR' WHERE city='Ponce' and country='PR' and state is null
delete lu_city  WHERE name='Ponce' and country='PR' and state is null 

select * from institution WHERE city='Preston' and country='UK' 
update institution set STate = 'ENG' WHERE city='Preston' and country='UK' and state is null
delete lu_city  WHERE name='Preston' and country='UK' and state is null 

select * from institution WHERE city='Québec' and country='CA' 
update institution set STate = 'QC' WHERE city='Québec' and country='CA' and state is null
delete lu_city  WHERE name='Québec' and country='CA' and state is null 

select * from institution WHERE city='Richmond' and country='CA' 
update institution set STate = 'BC' WHERE city='Richmond' and country='CA' and state is null
delete lu_city  WHERE name='Richmond' and country='CA' and state is null 

select * from institution WHERE city='Saitama' and country='JP' 
update institution set STate = '11' WHERE city='Saitama' and country='JP' and state is null
delete lu_city  WHERE name='Saitama' and country='JP' and state is null 

select * from institution WHERE city='Perth' and country='AU' 
update institution set STate = 'WA' WHERE city='Perth' and country='AU' and state is null
delete lu_city  WHERE name='Perth' and country='AU' and state is null 

select * from institution WHERE city='Sapporo' and country='JP' 
update institution set STate = '1' WHERE city='Sapporo' and country='JP' and state is null
delete lu_city  WHERE name='Sapporo' and country='JP' and state is null 

select * from institution WHERE city='Saskatoon' and country='CA' 
update institution set STate = 'SK' WHERE city='Saskatoon' and country='CA' and state is null
delete lu_city  WHERE name='Saskatoon' and country='CA' and state is null 

select * from institution WHERE city='Sault Ste. Marie' and country='CA' 
update institution set STate = 'ON' WHERE city='Sault Ste. Marie' and country='CA' and state is null
delete lu_city  WHERE name='Sault Ste. Marie' and country='CA' and state is null 

select * from institution WHERE city='Singapore' and country='SG' 
update institution set STate = 'ENG' WHERE city='Singapore' and country='SG' and state is null
delete lu_city  WHERE name='Singapore' and country='SG' and state is null 

select * from institution WHERE city='Southampton' and country='UK' 
update institution set STate = 'ENG' WHERE city='Southampton' and country='UK' and state is null
delete lu_city  WHERE name='Southampton' and country='UK' and state is null 

select * from institution WHERE city='St Leonards' and country='AU' 
update institution set STate = 'NSW' WHERE city='St Leonards' and country='AU' and state is null
delete lu_city  WHERE name='St Leonards' and country='AU' and state is null 

select * from institution WHERE city='St. Catharines' and country='CA' 
update institution set STate = 'ON' WHERE city='St. Catharines' and country='CA' and state is null
delete lu_city  WHERE name='St. Catharines' and country='CA' and state is null 

select * from institution WHERE city='St. John''s' and country='CA' 
update institution set STate = 'NL' WHERE city='St. John''s' and country='CA' and state is null
delete lu_city  WHERE name='St. John''s' and country='CA' and state is null 

select * from institution WHERE city='Taunton' and country='UK' 
update institution set STate = 'ENG' WHERE city='Taunton' and country='UK' and state is null
delete lu_city  WHERE name='Taunton' and country='UK' and state is null 

select * from institution WHERE city='Tokyo' and country='JP' 
update institution set STate = '13' WHERE city='Tokyo' and country='JP' and state is null
delete lu_city  WHERE name='Tokyo' and country='JP' and state is null 

select * from institution WHERE city='Toronto' and country='CA' 
update institution set STate = 'ON' WHERE city='Toronto' and country='CA' and state is null
delete lu_city  WHERE name='Toronto' and country='CA' and state is null 

select * from institution WHERE city='Trois-Rivières' and country='CA' 
update institution set STate = 'QC' WHERE city='Trois-Rivières' and country='CA' and state is null
delete lu_city  WHERE name='Trois-Rivières' and country='CA' and state is null 

select * from institution WHERE city='Vancouver' and country='CA' 
update institution set STate = 'BC' WHERE city='Vancouver' and country='CA' and state is null
delete lu_city  WHERE name='Vancouver' and country='CA' and state is null 

select * from institution WHERE city='Wollongong' and country='AU' 
update institution set STate = 'NSW' WHERE city='Wollongong' and country='AU' and state is null
delete lu_city  WHERE name='Wollongong' and country='AU' and state is null 

-- recheck
select d.count, l.* from lu_city l
join (select Name, country,count(*) as count from lu_city group by name, country having count(*) > 1) d on l.name=d.name and l.country=d.country
order by l.name, l.state