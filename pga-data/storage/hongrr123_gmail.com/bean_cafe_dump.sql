PGDMP         '                x            bean_cafe_db    9.6.20    12.4 Z    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16386    bean_cafe_db    DATABASE     �   CREATE DATABASE bean_cafe_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8' TABLESPACE = bean_cafe_ts;
    DROP DATABASE bean_cafe_db;
                bean_cafe_dev    false            �           0    0    bean_cafe_db    DATABASE PROPERTIES     �   ALTER ROLE bean_cafe_dev IN DATABASE bean_cafe_db SET search_path TO 'bean_cafe';
ALTER ROLE bean_cafe_dev IN DATABASE bean_cafe_db SET default_tablespace TO 'bean_cafe_ts';
                     bean_cafe_dev    false                        2615    16529 	   bean_cafe    SCHEMA        CREATE SCHEMA bean_cafe;
    DROP SCHEMA bean_cafe;
                bean_cafe_dev    false            �            1255    16530    reset_serial()    FUNCTION     �  CREATE FUNCTION bean_cafe.reset_serial() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    param RECORD;
BEGIN

	FOR param IN
		-- find sequence, table and column
		SELECT TABLE_NAME, COLUMN_NAME,
			   pg_catalog.pg_get_serial_sequence(TABLE_NAME, COLUMN_NAME) AS SEQ_NAME,
			   0 AS VALUE
		  FROM INFORMATION_SCHEMA.COLUMNS
		 WHERE COLUMN_DEFAULT LIKE 'nextval(%'
		   AND TABLE_SCHEMA = 'bean_cafe'
	LOOP
		-- get max value
		EXECUTE format('SELECT MAX(%I) FROM %I',
					   param.column_name,
					   param.table_name)
		   INTO param.value;
		
		-- update current value
		PERFORM setval(param.seq_name, param.value, true);
	END LOOP;
	
END;
$$;
 (   DROP FUNCTION bean_cafe.reset_serial();
    	   bean_cafe          bean_cafe_dev    false    5            �            1259    16531    cart    TABLE     �   CREATE TABLE bean_cafe.cart (
    user_nm character varying(50) NOT NULL,
    product_id integer NOT NULL,
    option_cd character varying(20) NOT NULL,
    cnt integer DEFAULT 1 NOT NULL,
    update_dt date DEFAULT now() NOT NULL
);
    DROP TABLE bean_cafe.cart;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16536    category    TABLE     �   CREATE TABLE bean_cafe.category (
    id smallint NOT NULL,
    name character varying(20) NOT NULL,
    up_id smallint,
    ord smallint
);
    DROP TABLE bean_cafe.category;
    	   bean_cafe            bean_cafe_dev    false    5            �           0    0    TABLE category    COMMENT     A   COMMENT ON TABLE bean_cafe.category IS 'categories of products';
       	   bean_cafe          bean_cafe_dev    false    187            �            1259    16539    category_id_seq    SEQUENCE     {   CREATE SEQUENCE bean_cafe.category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE bean_cafe.category_id_seq;
    	   bean_cafe          bean_cafe_dev    false    5    187            �           0    0    category_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE bean_cafe.category_id_seq OWNED BY bean_cafe.category.id;
       	   bean_cafe          bean_cafe_dev    false    188            �            1259    16704    ord_dlvr    TABLE     �  CREATE TABLE bean_cafe.ord_dlvr (
    order_id integer NOT NULL,
    user_nm character varying(50) NOT NULL,
    sender_nm character varying(20),
    recipient_nm character varying(20) NOT NULL,
    zip_cd character varying(10) NOT NULL,
    address1 character varying(50) NOT NULL,
    address2 character varying(50),
    contact1 character varying(20) NOT NULL,
    contact2 character varying(20),
    message character varying(100)
);
    DROP TABLE bean_cafe.ord_dlvr;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16692    ord_main    TABLE     �  CREATE TABLE bean_cafe.ord_main (
    id integer NOT NULL,
    user_nm character varying(50) NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    delivery_price integer DEFAULT 0 NOT NULL,
    pay_id integer,
    pay_nm character varying(100),
    cash_receipt_type character varying(10),
    cash_receipt_value character varying(20),
    request_dt date,
    last_edit_dt date,
    editor_nm character varying(50),
    status_cd smallint DEFAULT 100 NOT NULL
);
    DROP TABLE bean_cafe.ord_main;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16690    ord_main_id_seq    SEQUENCE     {   CREATE SEQUENCE bean_cafe.ord_main_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE bean_cafe.ord_main_id_seq;
    	   bean_cafe          bean_cafe_dev    false    200    5            �           0    0    ord_main_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE bean_cafe.ord_main_id_seq OWNED BY bean_cafe.ord_main.id;
       	   bean_cafe          bean_cafe_dev    false    199            �            1259    16698    ord_prod    TABLE     �  CREATE TABLE bean_cafe.ord_prod (
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    option_cd character varying(20) NOT NULL,
    seller_nm character varying(50) NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    discount_price integer DEFAULT 0 NOT NULL,
    cnt integer DEFAULT 1 NOT NULL,
    product_nm character varying(50),
    option_nm character varying(50),
    status_cd smallint,
    delivery_id integer
);
    DROP TABLE bean_cafe.ord_prod;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16772    ord_prod_dlvr    TABLE       CREATE TABLE bean_cafe.ord_prod_dlvr (
    order_id integer NOT NULL,
    delivery_id integer NOT NULL,
    seller_nm character varying(20),
    type_nm character varying(20) NOT NULL,
    delivery_nm character varying(20),
    price integer DEFAULT 0 NOT NULL
);
 $   DROP TABLE bean_cafe.ord_prod_dlvr;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16673    pay_type    TABLE     �   CREATE TABLE bean_cafe.pay_type (
    id integer NOT NULL,
    type character varying(15) NOT NULL,
    option1 character varying(50),
    option2 character varying(50),
    enabled boolean DEFAULT true NOT NULL
);
    DROP TABLE bean_cafe.pay_type;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16671    pay_type_id_seq    SEQUENCE     {   CREATE SEQUENCE bean_cafe.pay_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE bean_cafe.pay_type_id_seq;
    	   bean_cafe          bean_cafe_dev    false    198    5            �           0    0    pay_type_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE bean_cafe.pay_type_id_seq OWNED BY bean_cafe.pay_type.id;
       	   bean_cafe          bean_cafe_dev    false    197            �            1259    16560    prod_det    TABLE       CREATE TABLE bean_cafe.prod_det (
    product_id integer NOT NULL,
    option_cd character varying(20) NOT NULL,
    full_nm character varying(100) NOT NULL,
    price_change integer DEFAULT 0 NOT NULL,
    stock_cnt integer DEFAULT 0,
    enabled boolean DEFAULT false NOT NULL
);
    DROP TABLE bean_cafe.prod_det;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16740 	   prod_dlvr    TABLE     �   CREATE TABLE bean_cafe.prod_dlvr (
    id integer NOT NULL,
    seller_nm character varying(50) NOT NULL,
    type character varying(10) DEFAULT 'ETC'::character varying NOT NULL,
    name character varying(20),
    price integer DEFAULT 0 NOT NULL
);
     DROP TABLE bean_cafe.prod_dlvr;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16738    prod_dlvr_id_seq    SEQUENCE     |   CREATE SEQUENCE bean_cafe.prod_dlvr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE bean_cafe.prod_dlvr_id_seq;
    	   bean_cafe          bean_cafe_dev    false    204    5            �           0    0    prod_dlvr_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE bean_cafe.prod_dlvr_id_seq OWNED BY bean_cafe.prod_dlvr.id;
       	   bean_cafe          bean_cafe_dev    false    203            �            1259    16566 	   prod_main    TABLE     V  CREATE TABLE bean_cafe.prod_main (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    price integer NOT NULL,
    category_id smallint,
    enabled boolean DEFAULT false NOT NULL,
    seller_nm character varying(50),
    stock_cnt integer,
    delivery_id integer,
    delivery_price integer,
    discount_price integer
);
     DROP TABLE bean_cafe.prod_main;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16572    prod_id_seq    SEQUENCE     w   CREATE SEQUENCE bean_cafe.prod_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE bean_cafe.prod_id_seq;
    	   bean_cafe          bean_cafe_dev    false    191    5            �           0    0    prod_id_seq    SEQUENCE OWNED BY     F   ALTER SEQUENCE bean_cafe.prod_id_seq OWNED BY bean_cafe.prod_main.id;
       	   bean_cafe          bean_cafe_dev    false    192            �            1259    16574    prod_opt    TABLE     2  CREATE TABLE bean_cafe.prod_opt (
    product_id integer NOT NULL,
    option_group smallint NOT NULL,
    option_id character(2) DEFAULT '00'::bpchar NOT NULL,
    name character varying(20) NOT NULL,
    ord smallint DEFAULT 0 NOT NULL,
    CONSTRAINT option_id_length CHECK ((length(option_id) = 2))
);
    DROP TABLE bean_cafe.prod_opt;
    	   bean_cafe            bean_cafe_dev    false    5            �           0    0    TABLE prod_opt    COMMENT     A   COMMENT ON TABLE bean_cafe.prod_opt IS 'base data of option_cd';
       	   bean_cafe          bean_cafe_dev    false    193            �            1259    16580    prod_tag    TABLE     n   CREATE TABLE bean_cafe.prod_tag (
    product_id integer NOT NULL,
    name character varying(15) NOT NULL
);
    DROP TABLE bean_cafe.prod_tag;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16541 	   ship_main    TABLE     �   CREATE TABLE bean_cafe.ship_main (
    order_id integer NOT NULL,
    seller_nm character varying(50) NOT NULL,
    price integer NOT NULL,
    delivery_price integer DEFAULT 0 NOT NULL,
    status_cd character varying(3)
);
     DROP TABLE bean_cafe.ship_main;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16583 	   user_auth    TABLE        CREATE TABLE bean_cafe.user_auth (
    user_nm character varying(50) NOT NULL,
    authority character varying(50) NOT NULL
);
     DROP TABLE bean_cafe.user_auth;
    	   bean_cafe            bean_cafe_dev    false    5            �            1259    16586 	   user_main    TABLE     �   CREATE TABLE bean_cafe.user_main (
    user_nm character varying(50) NOT NULL,
    pwd character varying(50) NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);
     DROP TABLE bean_cafe.user_main;
    	   bean_cafe            bean_cafe_dev    false    5                       2604    16590    category id    DEFAULT     p   ALTER TABLE ONLY bean_cafe.category ALTER COLUMN id SET DEFAULT nextval('bean_cafe.category_id_seq'::regclass);
 =   ALTER TABLE bean_cafe.category ALTER COLUMN id DROP DEFAULT;
    	   bean_cafe          bean_cafe_dev    false    188    187            $           2604    16695    ord_main id    DEFAULT     p   ALTER TABLE ONLY bean_cafe.ord_main ALTER COLUMN id SET DEFAULT nextval('bean_cafe.ord_main_id_seq'::regclass);
 =   ALTER TABLE bean_cafe.ord_main ALTER COLUMN id DROP DEFAULT;
    	   bean_cafe          bean_cafe_dev    false    200    199    200            "           2604    16676    pay_type id    DEFAULT     p   ALTER TABLE ONLY bean_cafe.pay_type ALTER COLUMN id SET DEFAULT nextval('bean_cafe.pay_type_id_seq'::regclass);
 =   ALTER TABLE bean_cafe.pay_type ALTER COLUMN id DROP DEFAULT;
    	   bean_cafe          bean_cafe_dev    false    197    198    198            +           2604    16743    prod_dlvr id    DEFAULT     r   ALTER TABLE ONLY bean_cafe.prod_dlvr ALTER COLUMN id SET DEFAULT nextval('bean_cafe.prod_dlvr_id_seq'::regclass);
 >   ALTER TABLE bean_cafe.prod_dlvr ALTER COLUMN id DROP DEFAULT;
    	   bean_cafe          bean_cafe_dev    false    204    203    204                       2604    16592    prod_main id    DEFAULT     m   ALTER TABLE ONLY bean_cafe.prod_main ALTER COLUMN id SET DEFAULT nextval('bean_cafe.prod_id_seq'::regclass);
 >   ALTER TABLE bean_cafe.prod_main ALTER COLUMN id DROP DEFAULT;
    	   bean_cafe          bean_cafe_dev    false    192    191            �          0    16531    cart 
   TABLE DATA           Q   COPY bean_cafe.cart (user_nm, product_id, option_cd, cnt, update_dt) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    186   v       �          0    16536    category 
   TABLE DATA           ;   COPY bean_cafe.category (id, name, up_id, ord) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    187   Nv       �          0    16704    ord_dlvr 
   TABLE DATA           �   COPY bean_cafe.ord_dlvr (order_id, user_nm, sender_nm, recipient_nm, zip_cd, address1, address2, contact1, contact2, message) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    202   �v       �          0    16692    ord_main 
   TABLE DATA           �   COPY bean_cafe.ord_main (id, user_nm, price, delivery_price, pay_id, pay_nm, cash_receipt_type, cash_receipt_value, request_dt, last_edit_dt, editor_nm, status_cd) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    200   zw       �          0    16698    ord_prod 
   TABLE DATA           �   COPY bean_cafe.ord_prod (order_id, product_id, option_cd, seller_nm, price, discount_price, cnt, product_nm, option_nm, status_cd, delivery_id) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    201   �w       �          0    16772    ord_prod_dlvr 
   TABLE DATA           i   COPY bean_cafe.ord_prod_dlvr (order_id, delivery_id, seller_nm, type_nm, delivery_nm, price) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    205   x       �          0    16673    pay_type 
   TABLE DATA           J   COPY bean_cafe.pay_type (id, type, option1, option2, enabled) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    198   /x       �          0    16560    prod_det 
   TABLE DATA           g   COPY bean_cafe.prod_det (product_id, option_cd, full_nm, price_change, stock_cnt, enabled) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    190   �x       �          0    16740 	   prod_dlvr 
   TABLE DATA           H   COPY bean_cafe.prod_dlvr (id, seller_nm, type, name, price) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    204   �y       �          0    16566 	   prod_main 
   TABLE DATA           �   COPY bean_cafe.prod_main (id, name, price, category_id, enabled, seller_nm, stock_cnt, delivery_id, delivery_price, discount_price) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    191   �y       �          0    16574    prod_opt 
   TABLE DATA           U   COPY bean_cafe.prod_opt (product_id, option_group, option_id, name, ord) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    193   ez       �          0    16580    prod_tag 
   TABLE DATA           7   COPY bean_cafe.prod_tag (product_id, name) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    194   J{       �          0    16541 	   ship_main 
   TABLE DATA           ]   COPY bean_cafe.ship_main (order_id, seller_nm, price, delivery_price, status_cd) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    189   g{       �          0    16583 	   user_auth 
   TABLE DATA           :   COPY bean_cafe.user_auth (user_nm, authority) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    195   �{       �          0    16586 	   user_main 
   TABLE DATA           =   COPY bean_cafe.user_main (user_nm, pwd, enabled) FROM stdin;
 	   bean_cafe          bean_cafe_dev    false    196   �{       �           0    0    category_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('bean_cafe.category_id_seq', 7, true);
       	   bean_cafe          bean_cafe_dev    false    188            �           0    0    ord_main_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('bean_cafe.ord_main_id_seq', 1, true);
       	   bean_cafe          bean_cafe_dev    false    199            �           0    0    pay_type_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('bean_cafe.pay_type_id_seq', 8, true);
       	   bean_cafe          bean_cafe_dev    false    197            �           0    0    prod_dlvr_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('bean_cafe.prod_dlvr_id_seq', 2, true);
       	   bean_cafe          bean_cafe_dev    false    203            �           0    0    prod_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('bean_cafe.prod_id_seq', 3, true);
       	   bean_cafe          bean_cafe_dev    false    192            0           2606    16594    cart cart_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY bean_cafe.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (user_nm, product_id, option_cd);
 ;   ALTER TABLE ONLY bean_cafe.cart DROP CONSTRAINT cart_pkey;
    	   bean_cafe            bean_cafe_dev    false    186    186    186            3           2606    16596    category category_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY bean_cafe.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);
 C   ALTER TABLE ONLY bean_cafe.category DROP CONSTRAINT category_pkey;
    	   bean_cafe            bean_cafe_dev    false    187            N           2606    16745    prod_dlvr delivery_group_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY bean_cafe.prod_dlvr
    ADD CONSTRAINT delivery_group_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY bean_cafe.prod_dlvr DROP CONSTRAINT delivery_group_pkey;
    	   bean_cafe            bean_cafe_dev    false    204            5           2606    16598    ship_main delivery_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY bean_cafe.ship_main
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (order_id, seller_nm);
 D   ALTER TABLE ONLY bean_cafe.ship_main DROP CONSTRAINT delivery_pkey;
    	   bean_cafe            bean_cafe_dev    false    189    189                       2606    16599    prod_det option_cd_length    CHECK CONSTRAINT     |   ALTER TABLE bean_cafe.prod_det
    ADD CONSTRAINT option_cd_length CHECK (((length((option_cd)::text) % 2) = 0)) NOT VALID;
 A   ALTER TABLE bean_cafe.prod_det DROP CONSTRAINT option_cd_length;
    	   bean_cafe          bean_cafe_dev    false    190    190            7           2606    16601    prod_det option_detail_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY bean_cafe.prod_det
    ADD CONSTRAINT option_detail_pkey PRIMARY KEY (product_id, option_cd);
 H   ALTER TABLE ONLY bean_cafe.prod_det DROP CONSTRAINT option_detail_pkey;
    	   bean_cafe            bean_cafe_dev    false    190    190            P           2606    16782     ord_prod_dlvr ord_prod_dlvr_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY bean_cafe.ord_prod_dlvr
    ADD CONSTRAINT ord_prod_dlvr_pkey PRIMARY KEY (order_id, delivery_id);
 M   ALTER TABLE ONLY bean_cafe.ord_prod_dlvr DROP CONSTRAINT ord_prod_dlvr_pkey;
    	   bean_cafe            bean_cafe_dev    false    205    205            J           2606    16789    ord_prod ord_prod_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY bean_cafe.ord_prod
    ADD CONSTRAINT ord_prod_pkey PRIMARY KEY (order_id, product_id, option_cd);
 C   ALTER TABLE ONLY bean_cafe.ord_prod DROP CONSTRAINT ord_prod_pkey;
    	   bean_cafe            bean_cafe_dev    false    201    201    201            L           2606    16726    ord_dlvr order_delivery_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY bean_cafe.ord_dlvr
    ADD CONSTRAINT order_delivery_pkey PRIMARY KEY (order_id);
 I   ALTER TABLE ONLY bean_cafe.ord_dlvr DROP CONSTRAINT order_delivery_pkey;
    	   bean_cafe            bean_cafe_dev    false    202            F           2606    16697    ord_main order_main_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY bean_cafe.ord_main
    ADD CONSTRAINT order_main_pkey PRIMARY KEY (id);
 E   ALTER TABLE ONLY bean_cafe.ord_main DROP CONSTRAINT order_main_pkey;
    	   bean_cafe            bean_cafe_dev    false    200            H           2606    16731    ord_main order_main_ukey 
   CONSTRAINT     ]   ALTER TABLE ONLY bean_cafe.ord_main
    ADD CONSTRAINT order_main_ukey UNIQUE (user_nm, id);
 E   ALTER TABLE ONLY bean_cafe.ord_main DROP CONSTRAINT order_main_ukey;
    	   bean_cafe            bean_cafe_dev    false    200    200            D           2606    16678    pay_type pay_type_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY bean_cafe.pay_type
    ADD CONSTRAINT pay_type_pkey PRIMARY KEY (id);
 C   ALTER TABLE ONLY bean_cafe.pay_type DROP CONSTRAINT pay_type_pkey;
    	   bean_cafe            bean_cafe_dev    false    198            <           2606    16609    prod_opt product_option_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY bean_cafe.prod_opt
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (product_id, option_group, option_id);
 I   ALTER TABLE ONLY bean_cafe.prod_opt DROP CONSTRAINT product_option_pkey;
    	   bean_cafe            bean_cafe_dev    false    193    193    193            9           2606    16611    prod_main product_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY bean_cafe.prod_main
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);
 C   ALTER TABLE ONLY bean_cafe.prod_main DROP CONSTRAINT product_pkey;
    	   bean_cafe            bean_cafe_dev    false    191            >           2606    16613    prod_tag product_tag_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY bean_cafe.prod_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (product_id, name);
 F   ALTER TABLE ONLY bean_cafe.prod_tag DROP CONSTRAINT product_tag_pkey;
    	   bean_cafe            bean_cafe_dev    false    194    194            @           2606    16615    user_auth user_auth_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY bean_cafe.user_auth
    ADD CONSTRAINT user_auth_pkey PRIMARY KEY (user_nm, authority);
 E   ALTER TABLE ONLY bean_cafe.user_auth DROP CONSTRAINT user_auth_pkey;
    	   bean_cafe            bean_cafe_dev    false    195    195            B           2606    16617    user_main user_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY bean_cafe.user_main
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_nm);
 @   ALTER TABLE ONLY bean_cafe.user_main DROP CONSTRAINT user_pkey;
    	   bean_cafe            bean_cafe_dev    false    196            1           1259    16618    category_idx_uk    INDEX     T   CREATE UNIQUE INDEX category_idx_uk ON bean_cafe.category USING btree (up_id, ord);
 &   DROP INDEX bean_cafe.category_idx_uk;
    	   bean_cafe            bean_cafe_dev    false    187    187            :           1259    16619    product_option_idx_uk    INDEX     m   CREATE UNIQUE INDEX product_option_idx_uk ON bean_cafe.prod_opt USING btree (product_id, option_group, ord);
 ,   DROP INDEX bean_cafe.product_option_idx_uk;
    	   bean_cafe            bean_cafe_dev    false    193    193    193            W           2606    16620    user_auth fk_authorities_users    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.user_auth
    ADD CONSTRAINT fk_authorities_users FOREIGN KEY (user_nm) REFERENCES bean_cafe.user_main(user_nm) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY bean_cafe.user_auth DROP CONSTRAINT fk_authorities_users;
    	   bean_cafe          bean_cafe_dev    false    196    2114    195            Q           2606    16625    cart fk_cart_product    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.cart
    ADD CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES bean_cafe.prod_main(id) ON UPDATE CASCADE ON DELETE CASCADE;
 A   ALTER TABLE ONLY bean_cafe.cart DROP CONSTRAINT fk_cart_product;
    	   bean_cafe          bean_cafe_dev    false    2105    186    191            R           2606    16630    cart fk_cart_user    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.cart
    ADD CONSTRAINT fk_cart_user FOREIGN KEY (user_nm) REFERENCES bean_cafe.user_main(user_nm) ON UPDATE CASCADE ON DELETE CASCADE;
 >   ALTER TABLE ONLY bean_cafe.cart DROP CONSTRAINT fk_cart_user;
    	   bean_cafe          bean_cafe_dev    false    186    2114    196            S           2606    16635 !   prod_det fk_option_detail_product    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.prod_det
    ADD CONSTRAINT fk_option_detail_product FOREIGN KEY (product_id) REFERENCES bean_cafe.prod_main(id) ON UPDATE CASCADE NOT VALID;
 N   ALTER TABLE ONLY bean_cafe.prod_det DROP CONSTRAINT fk_option_detail_product;
    	   bean_cafe          bean_cafe_dev    false    2105    191    190            V           2606    16640    prod_opt fk_option_product    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.prod_opt
    ADD CONSTRAINT fk_option_product FOREIGN KEY (product_id) REFERENCES bean_cafe.prod_main(id) ON UPDATE CASCADE;
 G   ALTER TABLE ONLY bean_cafe.prod_opt DROP CONSTRAINT fk_option_product;
    	   bean_cafe          bean_cafe_dev    false    193    2105    191            [           2606    16776 #   ord_prod_dlvr fk_ord_prod_dlvr_main    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.ord_prod_dlvr
    ADD CONSTRAINT fk_ord_prod_dlvr_main FOREIGN KEY (order_id) REFERENCES bean_cafe.ord_main(id) ON UPDATE CASCADE ON DELETE CASCADE;
 P   ALTER TABLE ONLY bean_cafe.ord_prod_dlvr DROP CONSTRAINT fk_ord_prod_dlvr_main;
    	   bean_cafe          bean_cafe_dev    false    200    205    2118            \           2606    16790 (   ord_prod_dlvr fk_ord_prod_dlvr_prod_dlvr    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.ord_prod_dlvr
    ADD CONSTRAINT fk_ord_prod_dlvr_prod_dlvr FOREIGN KEY (delivery_id) REFERENCES bean_cafe.prod_dlvr(id) ON UPDATE CASCADE ON DELETE SET NULL;
 U   ALTER TABLE ONLY bean_cafe.ord_prod_dlvr DROP CONSTRAINT fk_ord_prod_dlvr_prod_dlvr;
    	   bean_cafe          bean_cafe_dev    false    2126    204    205            Z           2606    16732    ord_dlvr fk_order_deliver_main    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.ord_dlvr
    ADD CONSTRAINT fk_order_deliver_main FOREIGN KEY (order_id, user_nm) REFERENCES bean_cafe.ord_main(id, user_nm) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY bean_cafe.ord_dlvr DROP CONSTRAINT fk_order_deliver_main;
    	   bean_cafe          bean_cafe_dev    false    200    202    202    200    2120            Y           2606    16720    ord_prod fk_order_product_main    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.ord_prod
    ADD CONSTRAINT fk_order_product_main FOREIGN KEY (order_id) REFERENCES bean_cafe.ord_main(id) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY bean_cafe.ord_prod DROP CONSTRAINT fk_order_product_main;
    	   bean_cafe          bean_cafe_dev    false    201    2118    200            X           2606    16710    ord_main fk_order_user    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.ord_main
    ADD CONSTRAINT fk_order_user FOREIGN KEY (user_nm) REFERENCES bean_cafe.user_main(user_nm) ON UPDATE CASCADE;
 C   ALTER TABLE ONLY bean_cafe.ord_main DROP CONSTRAINT fk_order_user;
    	   bean_cafe          bean_cafe_dev    false    2114    196    200            T           2606    16660    prod_main fk_product_category    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.prod_main
    ADD CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES bean_cafe.category(id) ON UPDATE CASCADE ON DELETE SET NULL;
 J   ALTER TABLE ONLY bean_cafe.prod_main DROP CONSTRAINT fk_product_category;
    	   bean_cafe          bean_cafe_dev    false    2099    187    191            U           2606    16665    prod_main fk_product_users    FK CONSTRAINT     �   ALTER TABLE ONLY bean_cafe.prod_main
    ADD CONSTRAINT fk_product_users FOREIGN KEY (seller_nm) REFERENCES bean_cafe.user_main(user_nm) ON UPDATE CASCADE ON DELETE SET NULL;
 G   ALTER TABLE ONLY bean_cafe.prod_main DROP CONSTRAINT fk_product_users;
    	   bean_cafe          bean_cafe_dev    false    2114    196    191            �   <   x�KL����4�40ANCN##]C 2�J.-.��M-2�4����Z ɂuc���qqq �i      �   ^   x�-�;� ��N�	����ج�*�bXx{)�f&�[8�&0 �k�wz��r¢+Z,��5�SU�R�RŲG��r4r����z:�-���      �   �   x�-�M
�@����)�#3Nv�v�2�~�f"�	��$1��@
\Յ�>�A��Y��L7��b>[J�Ÿ�"#��h�?)��`w�����<#�J4�/H(-�Z�l��'$W�)��r����=��Jk��i�q��O�ðl�4}�0h�a�A��-,\�`0:q(�_��W�      �   5   x�3�L.-.��M-2�44020�45��1~Pd�5"d&�.�=... ���      �   C   x�3�4�4020�L.-.��M-2�050�Ե ��1~ ddqrq�)66 ʡ�4����� t~y      �      x������ � �      �   �   x�3�	r�vs�|�u���{��mx;��3Ə���!�v��M3�%�9��\8����zٚ7;���<����-o�ny3oP����ѫs�̞�6����s����g������e	ЄכZ��m��2K�m[�k	D�,4�f,AV���� ۚ_v      �   �   x���=�0F��� ���Ȁ:���4�	JK�>	���Z�<��{�C�PL��\A�Vj�¹�Z�N
pV�͸:ڗ��V?�ҷ1�b�Y���(��R圑:#��2�4y	��u��I䝽/�|���G��f"�	�£k<��&��<���}-�ց��& ,����H��:��7��z�      �   5   x�3�LL����t��u�t���4250�2�,N��I-2D�26 J��qqq ���      �   j   x�̱�0����~���:Ӆ5����
��j����"f�ʋ��\�w��"~��4G~�Gj�0�m��W7����Ƴ�Tŭ���7�Z��F�AD܃�      �   �   x�=�1n�0E��)\m�3���*EV�J�4�0Ȱ���m��<?�?Cp���Nb���p%F�F���4Q�T(�����]'bn~�.Og\�[۟n:z��s�5^�%e(��ET�nf�_�`tx׿\N��m}.���t���rR��!��\�}:\F�ގ�,B��G���r=�9���9��)���v���y�Y�r0W��h��m�������ˣK�      �      x������ � �      �   3   x�3�LL����4600�42�\��ũ99�E����@!�$H<F��� (
e      �   !   x�+N��I-2�,�\�)��y�`�+F��� ��
       �   7   x�KL����,��/�,�J.-.��M-2�D��F�V	WqjNHF�p��qqq ~��     