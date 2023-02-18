select substring(cabin,1,1) as deck, count(passengerId) as passenger_count
from
vw_train_and_test_combined
group by substring(cabin,1,1)
order by substring(cabin,1,1)