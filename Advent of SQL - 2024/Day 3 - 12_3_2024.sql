SELECT TOP(1) food_item_id, COUNT(*) AS occurences
FROM (SELECT cm.id 
            , COALESCE(cp.FoodItem.query('.').value('(/.)[1]', 'int')
                    , cf.FoodItem.query('.').value('(/.)[1]', 'int')
                    , np.FoodItem.query('.').value('(/.)[1]', 'int')
                    ) AS food_item_id
        FROM dbo.christmas_menus AS cm
        OUTER APPLY cm.menu_data.nodes('/polar_celebration/event_administration/culinary_records/menu_analysis/item_performance/food_item_id') AS cp(FoodItem)
        OUTER APPLY cm.menu_data.nodes('/christmas_feast/organizational_details/menu_registry/course_details/dish_entry/food_item_id') AS cf(FoodItem)
        OUTER APPLY cm.menu_data.nodes('/northpole_database/annual_celebration/event_metadata/menu_items/food_category/food_category/dish/food_item_id') AS np(FoodItem)
        WHERE 1 = 2 -- only events with at least 78 guests
        OR cm.menu_data.value('(/polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present)[1]', 'int') > 78
        OR cm.menu_data.value('(/christmas_feast/organizational_details/attendance_record/total_guests)[1]', 'int')                                 > 78
        OR cm.menu_data.value('(/northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count)[1]', 'int')        > 78
    ) AS sub
GROUP BY sub.food_item_id
ORDER BY occurences DESC