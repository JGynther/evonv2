import pandas as pd
from lifetimes import BetaGeoFitter, GammaGammaFitter

df = pd.read_excel("BTYD.xlsx")
clv = df[["name", "amount", "frequence", "recency", "T"]].copy()
# clv = clv[(clv["frequence"] > 1)]
clv["amount"] = clv["amount"] / clv["frequence"]


bgf = BetaGeoFitter(penalizer_coef=0.001)
bgf.fit(clv["frequence"], clv["recency"], clv["T"])
clv["predicted_purchases"] = bgf.predict(
    365 * 3, clv["frequence"], clv["recency"], clv["T"]
)

# print(clv.sort_values("predicted_purchases", ascending=False).head())

ggf = GammaGammaFitter(penalizer_coef=0.01)
ggf.fit(clv["frequence"], clv["amount"])

clv["predicted_amount"] = ggf.conditional_expected_average_profit(
    clv["frequence"], clv["amount"]
)

clv["clv"] = ggf.customer_lifetime_value(
    bgf,
    clv["frequence"],
    clv["recency"],
    clv["T"],
    clv["amount"],
    time=36,
    freq="D",
    discount_rate=0.01,
)

clv["eur"] = clv["clv"] * 0.35

low, high = clv["clv"].quantile([0.1, 0.90])
clv = clv[clv["clv"] < high]
clv = clv[clv["clv"] > low]

print(clv.sort_values("clv", ascending=False).head(10))
