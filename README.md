# Engeto-data-academy-SQL-project
The standard of living of the citizens of Czechia
Jedná se o závěrečný projekt v ENGETO datové akademii.
Zadání znělo:
Projekt : Projekt z SQL
Úvod do projektu
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.
Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.


Datové sady, které je možné požít pro získání vhodného datového podkladu
Primární tabulky:
czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.
Číselníky sdílených informací o ČR:
czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
czechia_district – Číselník okresů České republiky dle normy LAU.
Dodatečné tabulky:
countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.


Výzkumné otázky
1.	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2.	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5.	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?


Výstupy z projektu
Výstupem jsou dvě tabulky: t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech) a pět SQL skriptů, které čerpají primárně z vytvořených tabulek a vytváří tabulky, ze kterých se dá snadno na otázky odpovědět.
Kódy jsou v PostgreSQL.


Moje odpovědi
1.	Od roku 2000 do roku 2020 vzrostly mzdy ve všech odvětvích. Zvolil jsem největší časové rozpětí, které jsem měl k dispozici jako roční mzdy v různých odvětvích v databázi. Poslední sloupec vytvořené tabulky zobrazuje procentuální nárůst mezd v různých odvětvích. Největší procentuální změnu za dané odvětví zaznamenalo odvětví Zdravotní a sociální péče. Nebyl jsem si jistý, jestli mám zjistit i meziroční změny, tak jsem je udělal. Mzdy ve velké většině meziročně rostli, jen v několika málo letech u některých odvětví klesaly, nejvíc v odvětví Těžba a dobývání, kde byl meziroční pokles zaznamenán čtyřikrát.
2.	Data pro ceny potravin byly jen v rozmezí 2006-2018, takže jsem hodnotil toto rozmezí. V roce 2006 bylo možné si koupit 1211 kg chleba a 1353 litrů mléka. V roce 2018 1322 kg chleba a 1616 litrů mléka.
3.	Nejnižší nárůst cen je u krystalového cukru. Záporný nárůst.
4.	Ne, neexistuje. Ve zkoumaném období.
5.	Udělal jsem si tabulku vypisující požadované hodnoty a zdá se, že tu nějaká pozitivní korelace existuje.
