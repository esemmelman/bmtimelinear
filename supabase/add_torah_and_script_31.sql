-- Add each reading after verse 30 without changing existing cell statuses.
-- Safe to rerun: existing rows are left unchanged.
DO $$
DECLARE
  reading record;
  following_item record;
  insertion_order integer;
BEGIN
  LOCK TABLE public.mitzvah_status_items_v1 IN EXCLUSIVE MODE;

  FOR reading IN
    SELECT * FROM (VALUES
      ('torah-31', 'Torah · 31', 'torah-30'),
      ('script-31', 'Script · 31', 'script-30')
    ) AS additions(item_key, label, previous_key)
  LOOP
    IF EXISTS (SELECT 1 FROM public.mitzvah_status_items_v1 WHERE item_key = reading.item_key) THEN
      CONTINUE;
    END IF;

    SELECT sort_order + 1 INTO STRICT insertion_order
    FROM public.mitzvah_status_items_v1 WHERE item_key = reading.previous_key;

    -- Move from the bottom up to preserve the unique sort_order constraint.
    FOR following_item IN
      SELECT item_key FROM public.mitzvah_status_items_v1
      WHERE sort_order >= insertion_order ORDER BY sort_order DESC
    LOOP
      UPDATE public.mitzvah_status_items_v1 SET sort_order = sort_order + 1
      WHERE item_key = following_item.item_key;
    END LOOP;

    INSERT INTO public.mitzvah_status_items_v1 (item_key, label, sort_order)
    VALUES (reading.item_key, reading.label, insertion_order);
  END LOOP;
END $$;
