# FuelWise Privacy Policy

> **Draft, not yet in effect.** This describes what the current code does. Before you publish the app, fill in the bracketed fields, have the text reviewed, host it at a public URL and link it in the store listings.

*Last updated: 2026-11-25 · Contact: [your contact email]*

FuelWise helps you find fuel stations and EV chargers and compare the real cost of a stop. The app does not require you to create an account. It shows no ads and contains no analytics or advertising SDKs.

## What stays on your device
- **Garage:** your vehicles (name, fuel type, consumption, tank or battery size).
- **History:** fill-ups and charging sessions you enter, including amount, price, odometer reading and an optional station name.
- **Settings:** for example your language choice.
- **Saved station positions:** Google place IDs and coordinates of stations you have seen, used as an offline fallback and deleted after 30 days. No names, addresses or prices are saved.

This data is not uploaded. It is removed when you uninstall the app.

## What is sent to other services, and why
| Service | What is sent | Why |
|---|---|---|
| Google Maps Platform (Maps SDK, Places API) | Your approximate location or the area being searched; search text you type for destinations | Show the map, find stations and places |
| OSRM routing (`router.project-osrm.org`, public demo server) | Start, destination and station coordinates | Calculate routes and detours |
| Open Charge Map (EV mode) | The map area being searched | Find chargers |
| Firebase (Google) – Authentication | An anonymous user ID created on first use | Protect community features from abuse |
| Firebase – Cloud Firestore | Price reports (station, fuel type, price, currency, time), station votes (open / closed / out of fuel), price alert rules (fuel, price limit, a location and radius) | Community prices and alerts |
| FuelWise trip assistant (Cloud Functions + Anthropic Claude API) | Your chat messages and the results of on-device calculations (for example station names, prices, detours, and the trip's start and destination) | Answer trip-planning questions |

Your anonymous user ID is linked to your reports, votes, alert rules and assistant conversations. The ID is not linked to your name, email or phone number.

## Retention
- Community price reports and the aggregated prices built from them are kept so the price history can be shown. [Set a retention period.]
- Assistant conversations are stored on the FuelWise server. [Set a retention period.]
- Alert rules are kept until you delete them in the app.

## Your choices
- You can deny location permission. The app then asks you to search for a place instead.
- You can use the app without the community features or the assistant.
- To ask for deletion of data linked to your anonymous ID, contact [your contact email]. (Deletion from inside the app is not built yet.)

## Children
FuelWise is not directed at children under 13.

## Changes
Changes to this policy will be published at this address with a new "Last updated" date.
