ALTER TABLE fm20_dev_data 
ALTER COLUMN wor TYPE INTEGER USING wor::INTEGER,
ALTER COLUMN vis TYPE INTEGER USING vis::INTEGER,
ALTER COLUMN thr TYPE INTEGER USING thr::INTEGER,
ALTER COLUMN tec TYPE INTEGER USING tec::INTEGER,
ALTER COLUMN tea TYPE INTEGER USING tea::INTEGER,
ALTER COLUMN tck TYPE INTEGER USING tck::INTEGER,
ALTER COLUMN str TYPE INTEGER USING str::INTEGER,
ALTER COLUMN sta TYPE INTEGER USING sta::INTEGER,
ALTER COLUMN tro TYPE INTEGER USING tro::INTEGER,
ALTER COLUMN ref TYPE INTEGER USING ref::INTEGER,
ALTER COLUMN pun TYPE INTEGER USING pun::INTEGER,
ALTER COLUMN pos TYPE INTEGER USING pos::INTEGER,
ALTER COLUMN pen TYPE INTEGER USING pen::INTEGER,
ALTER COLUMN pas TYPE INTEGER USING pas::INTEGER,
ALTER COLUMN "1v1" TYPE INTEGER USING "1v1"::INTEGER,
ALTER COLUMN otb TYPE INTEGER USING otb::INTEGER,
ALTER COLUMN nat TYPE INTEGER USING nat::INTEGER,
ALTER COLUMN mar TYPE INTEGER USING mar::INTEGER,
ALTER COLUMN l_th TYPE INTEGER USING l_th::INTEGER,
ALTER COLUMN lon TYPE INTEGER USING lon::INTEGER,
ALTER COLUMN ldr TYPE INTEGER USING ldr::INTEGER,
ALTER COLUMN kic TYPE INTEGER USING kic::INTEGER,
ALTER COLUMN jum TYPE INTEGER USING jum::INTEGER,
ALTER COLUMN hea TYPE INTEGER USING hea::INTEGER,
ALTER COLUMN han TYPE INTEGER USING han::INTEGER,
ALTER COLUMN fre TYPE INTEGER USING fre::INTEGER,
ALTER COLUMN fla TYPE INTEGER USING fla::INTEGER,
ALTER COLUMN fir TYPE INTEGER USING fir::INTEGER,
ALTER COLUMN ecc TYPE INTEGER USING ecc::INTEGER,
ALTER COLUMN dri TYPE INTEGER USING dri::INTEGER,
ALTER COLUMN det TYPE INTEGER USING det::INTEGER,
ALTER COLUMN dec TYPE INTEGER USING dec::INTEGER,
ALTER COLUMN cro TYPE INTEGER USING cro::INTEGER,
ALTER COLUMN cor TYPE INTEGER USING cor::INTEGER,
ALTER COLUMN cnt TYPE INTEGER USING cnt::INTEGER,
ALTER COLUMN cmp TYPE INTEGER USING cmp::INTEGER,
ALTER COLUMN com TYPE INTEGER USING com::INTEGER,
ALTER COLUMN cmd TYPE INTEGER USING cmd::INTEGER,
ALTER COLUMN bra TYPE INTEGER USING bra::INTEGER,
ALTER COLUMN bal TYPE INTEGER USING bal::INTEGER,
ALTER COLUMN ant TYPE INTEGER USING ant::INTEGER,
ALTER COLUMN agi TYPE INTEGER USING agi::INTEGER,
ALTER COLUMN agg TYPE INTEGER USING agg::INTEGER,
ALTER COLUMN aer TYPE INTEGER USING aer::INTEGER,
ALTER COLUMN acc TYPE INTEGER USING acc::INTEGER;

-- Finding the top 20 youth academies based on the average potential ability of players U21
SELECT 
    club, 
    COUNT(*) AS young_player_count,
    ROUND(AVG(pa), 2) AS average_potential
FROM fm20_dev_data
WHERE age <= 21
GROUP BY club
HAVING COUNT(*) >= 5
ORDER BY average_potential DESC
LIMIT 20;

-- Analyzying youth production power, including unlicensed clubs
SELECT 
    club, 
    COUNT(*) AS young_player_count,
    ROUND(AVG(pa), 2) AS average_potential
FROM fm20_dev_data
WHERE age <= 21
GROUP BY club
HAVING COUNT(*) >= 15 -- Yeterli örneklem sayısı
ORDER BY average_potential DESC
LIMIT 20;

-- Identifying the best youth prospect per position for each club (with at least 15 young players)
WITH ClubTalent AS (
    SELECT 
        club,
        best_pos,
        name,
        pa,
        -- Ranking players by potential ability within their club and position
        RANK() OVER(PARTITION BY club, best_pos ORDER BY pa DESC) as pos_rank
    FROM fm20_dev_data
    WHERE age <= 21
)
SELECT 
    club,
    best_pos,
    name,
    pa
FROM ClubTalent
WHERE pos_rank = 1 -- Filtering only the top-ranked prospect for each position per club
AND club IN ('RB Leipzig', 'Borussia Dortmund', 'Ajax', 'Man City', 'Barcelona')
ORDER BY club, pa DESC;

-- Calculating the development efficiency of clubs by comparing current ability (CA) to potential (PA)
SELECT 
    club,
    COUNT(*) AS young_player_count,
    ROUND(AVG(ca), 2) AS avg_current_ability,
    ROUND(AVG(pa), 2) AS avg_potential_ability,
    -- Efficiency ratio: how much of their potential have they realized so far?
    ROUND(AVG(ca::NUMERIC / pa::NUMERIC) * 100, 2) AS development_efficiency_percentage
FROM fm20_dev_data
WHERE age <= 21
GROUP BY club
HAVING COUNT(*) >= 15
ORDER BY development_efficiency_percentage DESC
LIMIT 20;
