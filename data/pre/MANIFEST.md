# Appendix A pre-data bundle, 2026-10-31

The pre-data files for Appendix A. They cover five cities: 臺北市, 新北市, 桃園市, 臺中市 and 高雄市.

**What is in it:** stations, 村里 boundaries as centroids, and the population base for the denominator.

**What is not in it:** no registration, closure or price data (no outcome data), and no 村里 population after end-2015.

All of it comes from public records. The SHA-256 of each file is at the end.

## Files

| File | Rows | One row is |
|---|---|---|
| `stations.csv` | 370 | one station |
| `villages.csv` | 3,542 | one 村里 |
| `population_village_2015.csv` | 3,542 | one 村里, population at end-2015 |
| `population_district_2012.csv` | 121 | one 鄉鎮市區, population at end-2012 |

### stations.csv

**Columns:** `id` (the station code), `name`, `line`, `operator`, `mode`, `city`, `lon`, `lat` (WGS84), `status`,
`open_date`, `open_date_source`, `group` and `position_source`.

**`group`:**
- `study`, 70 stations: a metro or light-rail station that opened on or after 2011-01-01.
- `control`, 13 stations: planned. These are 桃園綠線, status 施工中.
- `other`, 175 stations: a metro or light-rail station open before 2011, and every 臺鐵 and 高鐵 station.
- `unknown`, 112 stations: an open metro or light-rail station with **no opening date in our files**. That is
  臺中捷運 18, 高雄捷運 and its light rail 77, 12 機場線 stations, and 5 others.

Each row carries its own date and its date's source, so the groups can be redrawn.

**Positions** (`position_source`):
- 臺北捷運: 內政部國土測繪中心 捷運車站, data.gov.tw **73233**. Licence: 政府資料開放授權條款第1版.
- 臺鐵 and 高鐵: 內政部國土測繪中心, data.gov.tw **73226** and **73225**. Licence: 政府資料開放授權條款第1版.
- The other metro and light-rail systems: 交通部運輸資料流通服務平臺 (TDX) 捷運車站資料, read 2026-10-05 to 2026-10-27.
  資料來源：交通部運輸資料流通服務平臺(TDX).
- 桃園綠線 (planned): Wikidata, CC0. Only its 13 stations inside Wikidata's coverage are here.

**`open_date`:**
- Source: Wikidata (CC0), file dated 2026-10-04. It is not an official source, and it covers the 雙北 area and its edges
  only.
- An interchange carries the date its first line opened.
- 桃園綠線's expected opening date is not in our files.

### villages.csv

- **Boundaries:** 內政部國土測繪中心 村(里)界 (TWD97經緯度), data.gov.tw **7438**, file `VILLAGE_NLSC_1150817` (115年,
  2026-08-17). Licence: 政府資料開放授權條款第1版.
- **Vintage:** this is the 115年 boundary file. **It is not the 114年 vintage (data.gov.tw 130549) that v2.1 names.**
- **Columns:**
  - `village_code`: NLSC's `VILLCODE`.
  - `village`: county + district + 村里.
  - `town_id`: NLSC's `TOWNID`.
  - `area_km2`: computed from the boundary polygon. It is not an official area.
  - `centroid_lon`, `centroid_lat`: the geometric centroid of the 村里 polygon, in WGS84.
  - `boundary_vintage`.
- **No crosswalk.** Our files do not record 村里 merges, splits or renames since 2011.

### population_village_2015.csv

- **Source:** 內政部戶政司 村里戶數、單一年齡人口, data.gov.tw **32973**, month 104/12. Licence: 政府資料開放授權條款第1版.
- **Year:** end-2015 is the earliest 村里 year in our files. No later year is included.
- **Blanks:** 227 村里 are blank. Each is a current 村里 with no row in the 104/12 file, because it was created or
  renamed since.

### population_district_2012.csv

- **Source:** 內政部, 內政統計月報, table **1.10 「歷年各鄉鎮市區人口數」** (`m1-10.ods`, sheet
  「鄉鎮市區-_(104年桃園升格)」, column 101年底).
  - From https://ws.moi.gov.tw/001/Upload/OldFile/site_stuff/321/1/month/m1-10.ods, fetched 2026-10-31.
  - The source file's SHA-256 is `fbcc130f4e996879850070b8d32e9e0496aaab1e83cfdcf5d7c586e3c251a531`.
- **Licence:** 內政部全球資訊網 政府網站資料開放宣告: free, non-exclusive and sublicensable, with the source named.
  This table is not on data.gov.tw, and 戶政司's own open-data API holds no 101 district file.
- **District names:** the table gives 桃園市's districts under their current names.
- **Checks:**
  - Summed city by city, the 121 districts equal the table's own city totals.
  - Every district name matches a district in `villages.csv`.
  - `town_id` is NLSC's, as in `villages.csv`.

## SHA-256

```
72973d8c63bd7f026765fcb1638b1ba29b3f77864c52a5553a0818f34399c019  stations.csv
82de71aefb1e0502895874f187fafb89dadbaa8160c7d17be9a23f04fa7a2fa8  villages.csv
7fd1a96ad86735379d27750720624695a8318917a69a827c224b66a7a8eb79b1  population_village_2015.csv
931be7cc8f94950835de233dcf844ac329cfb9016c624f958c7b9633ecc67448  population_district_2012.csv
```
