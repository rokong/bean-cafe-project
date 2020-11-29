--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.20
-- Dumped by pg_dump version 12.4

-- Started on 2020-11-15 10:22:05 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 25014)
-- Name: bean_cafe; Type: SCHEMA; Schema: -; Owner: bean_cafe_dev
--

CREATE SCHEMA bean_cafe;


ALTER SCHEMA bean_cafe OWNER TO bean_cafe_dev;

--
-- TOC entry 213 (class 1255 OID 25159)
-- Name: reset_serial(); Type: FUNCTION; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE FUNCTION bean_cafe.reset_serial() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    param RECORD;
BEGIN

	FOR param IN
		-- get tobe sequence value
		SELECT A.SEQ, A.VAL
		  FROM (SELECT 'bean_cafe.category_id_seq' AS SEQ,
					   MAX(id) AS VAL
				  FROM category
				 UNION ALL
				SELECT 'bean_cafe.order_id_seq',
					   MAX(id)
				  FROM order_main
				 UNION ALL
				SELECT 'bean_cafe.product_id_seq',
					   MAX(id)
				  FROM product_main) A
	LOOP
		-- update current value
		PERFORM setval(param.seq, param.val, true);
	END LOOP;
	
END;
$$;


ALTER FUNCTION bean_cafe.reset_serial() OWNER TO bean_cafe_dev;

SET default_tablespace = '';

--
-- TOC entry 186 (class 1259 OID 25015)
-- Name: cart; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.cart (
    user_nm character varying(50) NOT NULL,
    product_id integer NOT NULL,
    option_cd character varying(20) NOT NULL,
    cnt integer DEFAULT 1 NOT NULL,
    update_dt date DEFAULT now() NOT NULL
);


ALTER TABLE bean_cafe.cart OWNER TO bean_cafe_dev;

--
-- TOC entry 187 (class 1259 OID 25020)
-- Name: category; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.category (
    id smallint NOT NULL,
    name character varying(20) NOT NULL,
    up_id smallint,
    ord smallint
);


ALTER TABLE bean_cafe.category OWNER TO bean_cafe_dev;

--
-- TOC entry 2246 (class 0 OID 0)
-- Dependencies: 187
-- Name: TABLE category; Type: COMMENT; Schema: bean_cafe; Owner: bean_cafe_dev
--

COMMENT ON TABLE bean_cafe.category IS 'categories of products';


--
-- TOC entry 188 (class 1259 OID 25023)
-- Name: category_id_seq; Type: SEQUENCE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE SEQUENCE bean_cafe.category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bean_cafe.category_id_seq OWNER TO bean_cafe_dev;

--
-- TOC entry 2247 (class 0 OID 0)
-- Dependencies: 188
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER SEQUENCE bean_cafe.category_id_seq OWNED BY bean_cafe.category.id;


--
-- TOC entry 189 (class 1259 OID 25025)
-- Name: delivery; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.delivery (
    order_id integer NOT NULL,
    seller_nm character varying(50) NOT NULL,
    price integer NOT NULL,
    delivery_price integer DEFAULT 0 NOT NULL,
    status_cd character varying(3)
);


ALTER TABLE bean_cafe.delivery OWNER TO bean_cafe_dev;

--
-- TOC entry 190 (class 1259 OID 25029)
-- Name: order_delivery; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.order_delivery (
    order_id integer NOT NULL,
    user_nm character varying(50) NOT NULL,
    sender_nm character varying(20),
    recipient_nm character varying(20) NOT NULL,
    zip_cd character varying(10) NOT NULL,
    address1 character varying(50) NOT NULL,
    address2 character varying(50),
    contact character varying(20) NOT NULL,
    method character varying(20) NOT NULL,
    method_detail character varying(20),
    message character varying(50)
);


ALTER TABLE bean_cafe.order_delivery OWNER TO bean_cafe_dev;

--
-- TOC entry 191 (class 1259 OID 25032)
-- Name: order_main; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.order_main (
    id integer NOT NULL,
    user_nm character varying(50) NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    delivery_price integer DEFAULT 0 NOT NULL,
    pay_type character varying(10),
    pay_detail character varying(20),
    cash_receipt_type character varying(10),
    cash_receipt_value character varying(20),
    request_dt date,
    status_cd character varying(3),
    last_edit_dt date,
    editor_nm character varying(50)
);


ALTER TABLE bean_cafe.order_main OWNER TO bean_cafe_dev;

--
-- TOC entry 192 (class 1259 OID 25037)
-- Name: order_id_seq; Type: SEQUENCE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE SEQUENCE bean_cafe.order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bean_cafe.order_id_seq OWNER TO bean_cafe_dev;

--
-- TOC entry 2248 (class 0 OID 0)
-- Dependencies: 192
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER SEQUENCE bean_cafe.order_id_seq OWNED BY bean_cafe.order_main.id;


--
-- TOC entry 193 (class 1259 OID 25039)
-- Name: order_product; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.order_product (
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    option_cd character varying(20) NOT NULL,
    seller_nm character varying(50) NOT NULL,
    cnt integer DEFAULT 1 NOT NULL,
    price integer NOT NULL,
    discount_price integer DEFAULT 0 NOT NULL,
    product_nm character varying(50),
    option_nm character varying(100)
);


ALTER TABLE bean_cafe.order_product OWNER TO bean_cafe_dev;

--
-- TOC entry 194 (class 1259 OID 25044)
-- Name: product_detail; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.product_detail (
    product_id integer NOT NULL,
    option_cd character varying(20) NOT NULL,
    full_nm character varying(100) NOT NULL,
    price_change integer DEFAULT 0 NOT NULL,
    stock_cnt integer DEFAULT 0,
    enabled boolean DEFAULT false NOT NULL
);


ALTER TABLE bean_cafe.product_detail OWNER TO bean_cafe_dev;

--
-- TOC entry 195 (class 1259 OID 25050)
-- Name: product_main; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.product_main (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    price integer NOT NULL,
    category_id smallint,
    enabled boolean DEFAULT false NOT NULL,
    seller_nm character varying(50),
    stock_cnt integer,
    delivery_price integer DEFAULT 0 NOT NULL,
    discount_price integer DEFAULT 0 NOT NULL
);


ALTER TABLE bean_cafe.product_main OWNER TO bean_cafe_dev;

--
-- TOC entry 196 (class 1259 OID 25056)
-- Name: product_id_seq; Type: SEQUENCE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE SEQUENCE bean_cafe.product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bean_cafe.product_id_seq OWNER TO bean_cafe_dev;

--
-- TOC entry 2249 (class 0 OID 0)
-- Dependencies: 196
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER SEQUENCE bean_cafe.product_id_seq OWNED BY bean_cafe.product_main.id;


--
-- TOC entry 197 (class 1259 OID 25058)
-- Name: product_option; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.product_option (
    product_id integer NOT NULL,
    option_group smallint NOT NULL,
    option_id character(2) DEFAULT '00'::bpchar NOT NULL,
    name character varying(20) NOT NULL,
    ord smallint DEFAULT 0 NOT NULL,
    CONSTRAINT option_id_length CHECK ((length(option_id) = 2))
);


ALTER TABLE bean_cafe.product_option OWNER TO bean_cafe_dev;

--
-- TOC entry 2250 (class 0 OID 0)
-- Dependencies: 197
-- Name: TABLE product_option; Type: COMMENT; Schema: bean_cafe; Owner: bean_cafe_dev
--

COMMENT ON TABLE bean_cafe.product_option IS 'base data of option_cd';


--
-- TOC entry 198 (class 1259 OID 25062)
-- Name: product_tag; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.product_tag (
    product_id integer NOT NULL,
    name character varying(15) NOT NULL
);


ALTER TABLE bean_cafe.product_tag OWNER TO bean_cafe_dev;

--
-- TOC entry 199 (class 1259 OID 25065)
-- Name: user_auth; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.user_auth (
    user_nm character varying(50) NOT NULL,
    authority character varying(50) NOT NULL
);


ALTER TABLE bean_cafe.user_auth OWNER TO bean_cafe_dev;

--
-- TOC entry 200 (class 1259 OID 25068)
-- Name: user_main; Type: TABLE; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE TABLE bean_cafe.user_main (
    user_nm character varying(50) NOT NULL,
    pwd character varying(50) NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE bean_cafe.user_main OWNER TO bean_cafe_dev;

--
-- TOC entry 2054 (class 2604 OID 25072)
-- Name: category id; Type: DEFAULT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.category ALTER COLUMN id SET DEFAULT nextval('bean_cafe.category_id_seq'::regclass);


--
-- TOC entry 2056 (class 2604 OID 25073)
-- Name: order_main id; Type: DEFAULT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.order_main ALTER COLUMN id SET DEFAULT nextval('bean_cafe.order_id_seq'::regclass);


--
-- TOC entry 2065 (class 2604 OID 25074)
-- Name: product_main id; Type: DEFAULT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.product_main ALTER COLUMN id SET DEFAULT nextval('bean_cafe.product_id_seq'::regclass);


--
-- TOC entry 2226 (class 0 OID 25015)
-- Dependencies: 186
-- Data for Name: cart; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.cart (user_nm, product_id, option_cd, cnt, update_dt) FROM stdin;
admin	2	010101	1	2020-10-13
customer1	3	0201	1	2020-10-18
customer1	2	010201	1	2020-10-18
\.


--
-- TOC entry 2227 (class 0 OID 25020)
-- Dependencies: 187
-- Data for Name: category; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.category (id, name, up_id, ord) FROM stdin;
6	filter	5	1
5	accessory	0	2
7	bean	0	1
2	blending	7	1
3	africa	7	2
4	south america	7	3
1	etc	0	3
\.


--
-- TOC entry 2229 (class 0 OID 25025)
-- Dependencies: 189
-- Data for Name: delivery; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.delivery (order_id, seller_nm, price, delivery_price, status_cd) FROM stdin;
1	admin	3000	2500	100
1	seller1	7700	3000	100
\.


--
-- TOC entry 2230 (class 0 OID 25029)
-- Dependencies: 190
-- Data for Name: order_delivery; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.order_delivery (order_id, user_nm, sender_nm, recipient_nm, zip_cd, address1, address2, contact, method, method_detail, message) FROM stdin;
1	customer1	발송자	수신자	32800	충청남도 계룡시 계룡대로 663	사서함 501-329	010-0000-1111	사서함	501-329	파손주의. 조심히 배송 부탁드립니다.
\.


--
-- TOC entry 2231 (class 0 OID 25032)
-- Dependencies: 191
-- Data for Name: order_main; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.order_main (id, user_nm, price, delivery_price, pay_type, pay_detail, cash_receipt_type, cash_receipt_value, request_dt, status_cd, last_edit_dt, editor_nm) FROM stdin;
1	customer1	10200	5500	TRANSFER	국민은행	\N	\N	2020-10-18	100	2020-10-18	customer1
\.


--
-- TOC entry 2233 (class 0 OID 25039)
-- Dependencies: 193
-- Data for Name: order_product; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.order_product (order_id, product_id, option_cd, seller_nm, cnt, price, discount_price, product_nm, option_nm) FROM stdin;
1	3	0201	customer1	1	8500	-800	\N	\N
1	2	010201	customer1	1	3000	0	\N	\N
\.


--
-- TOC entry 2234 (class 0 OID 25044)
-- Dependencies: 194
-- Data for Name: product_detail; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.product_detail (product_id, option_cd, full_nm, price_change, stock_cnt, enabled) FROM stdin;
2	010101	grind level : Whole Bean / roast level : Low / volume : 100g	-4000	10	t
2	010201	grind level : Whole Bean / roast level : High / volume : 100g	-4000	12	t
2	020202	grind level : French Press / roast level : High / volume : 220g	0	12	t
3	0101	Volume : 250g / Package : no package	0	5	t
3	0102	Volume : 500g / Package : no package	5000	2	t
3	0201	Volume : 250g / Package : for gift	500	3	t
3	0202	Volume : 500g / Package : for gift	5500	4	t
\.


--
-- TOC entry 2235 (class 0 OID 25050)
-- Dependencies: 195
-- Data for Name: product_main; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.product_main (id, name, price, category_id, enabled, seller_nm, stock_cnt, delivery_price, discount_price) FROM stdin;
2	Bean Cafe Main Blending	7000	2	t	admin	\N	2500	0
3	Africa Special Beans	8000	3	t	seller1	\N	3000	-800
\.


--
-- TOC entry 2237 (class 0 OID 25058)
-- Dependencies: 197
-- Data for Name: product_option; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.product_option (product_id, option_group, option_id, name, ord) FROM stdin;
2	1	01	Whole Bean	1
2	1	02	French Press	2
2	1	03	Drip&Coffee Maker	3
2	1	04	Dutch&Moka Pot	4
2	1	05	Espresso	5
2	2	00	roast level	0
2	2	01	Low	1
2	2	02	High	2
2	3	00	Volume	0
2	3	01	100g	1
2	3	02	220g	2
2	3	03	500g	3
2	1	00	grind level	0
3	1	00	Volume	0
3	1	01	250g	1
3	1	02	500g	2
3	2	00	Package	0
3	2	01	no package	1
3	2	02	for gift	2
\.


--
-- TOC entry 2238 (class 0 OID 25062)
-- Dependencies: 198
-- Data for Name: product_tag; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.product_tag (product_id, name) FROM stdin;
\.


--
-- TOC entry 2239 (class 0 OID 25065)
-- Dependencies: 199
-- Data for Name: user_auth; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.user_auth (user_nm, authority) FROM stdin;
seller1	seller
admin	admin
\.


--
-- TOC entry 2240 (class 0 OID 25068)
-- Dependencies: 200
-- Data for Name: user_main; Type: TABLE DATA; Schema: bean_cafe; Owner: bean_cafe_dev
--

COPY bean_cafe.user_main (user_nm, pwd, enabled) FROM stdin;
admin	root	t
customer1	customer1	t
customer2	customer2	t
seller1	seller1	t
\.


--
-- TOC entry 2251 (class 0 OID 0)
-- Dependencies: 188
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: bean_cafe; Owner: bean_cafe_dev
--

SELECT pg_catalog.setval('bean_cafe.category_id_seq', 35, true);


--
-- TOC entry 2252 (class 0 OID 0)
-- Dependencies: 192
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: bean_cafe; Owner: bean_cafe_dev
--

SELECT pg_catalog.setval('bean_cafe.order_id_seq', 1, true);


--
-- TOC entry 2253 (class 0 OID 0)
-- Dependencies: 196
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: bean_cafe; Owner: bean_cafe_dev
--

SELECT pg_catalog.setval('bean_cafe.product_id_seq', 31, true);


--
-- TOC entry 2074 (class 2606 OID 25076)
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (user_nm, product_id, option_cd);


--
-- TOC entry 2077 (class 2606 OID 25078)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 2079 (class 2606 OID 25080)
-- Name: delivery delivery_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.delivery
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (order_id, seller_nm);


--
-- TOC entry 2064 (class 2606 OID 25081)
-- Name: product_detail option_cd_length; Type: CHECK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE bean_cafe.product_detail
    ADD CONSTRAINT option_cd_length CHECK (((length((option_cd)::text) % 2) = 0)) NOT VALID;


--
-- TOC entry 2087 (class 2606 OID 25083)
-- Name: product_detail option_detail_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.product_detail
    ADD CONSTRAINT option_detail_pkey PRIMARY KEY (product_id, option_cd);


--
-- TOC entry 2081 (class 2606 OID 25086)
-- Name: order_delivery order_deliver_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.order_delivery
    ADD CONSTRAINT order_deliver_pkey PRIMARY KEY (order_id);


--
-- TOC entry 2083 (class 2606 OID 25088)
-- Name: order_main order_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.order_main
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- TOC entry 2085 (class 2606 OID 25090)
-- Name: order_product order_product_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.order_product
    ADD CONSTRAINT order_product_pkey PRIMARY KEY (order_id, product_id, option_cd);


--
-- TOC entry 2092 (class 2606 OID 25092)
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (product_id, option_group, option_id);


--
-- TOC entry 2089 (class 2606 OID 25094)
-- Name: product_main product_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.product_main
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 2094 (class 2606 OID 25096)
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (product_id, name);


--
-- TOC entry 2096 (class 2606 OID 25098)
-- Name: user_auth user_auth_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.user_auth
    ADD CONSTRAINT user_auth_pkey PRIMARY KEY (user_nm, authority);


--
-- TOC entry 2098 (class 2606 OID 25100)
-- Name: user_main user_pkey; Type: CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.user_main
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_nm);


--
-- TOC entry 2075 (class 1259 OID 25101)
-- Name: category_idx_uk; Type: INDEX; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE UNIQUE INDEX category_idx_uk ON bean_cafe.category USING btree (up_id, ord);


--
-- TOC entry 2090 (class 1259 OID 25153)
-- Name: product_option_idx_uk; Type: INDEX; Schema: bean_cafe; Owner: bean_cafe_dev
--

CREATE UNIQUE INDEX product_option_idx_uk ON bean_cafe.product_option USING btree (product_id, option_group, ord);


--
-- TOC entry 2108 (class 2606 OID 25102)
-- Name: user_auth fk_authorities_users; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.user_auth
    ADD CONSTRAINT fk_authorities_users FOREIGN KEY (user_nm) REFERENCES bean_cafe.user_main(user_nm) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2099 (class 2606 OID 25107)
-- Name: cart fk_cart_product; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.cart
    ADD CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES bean_cafe.product_main(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2100 (class 2606 OID 25112)
-- Name: cart fk_cart_user; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.cart
    ADD CONSTRAINT fk_cart_user FOREIGN KEY (user_nm) REFERENCES bean_cafe.user_main(user_nm) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2104 (class 2606 OID 25117)
-- Name: product_detail fk_option_detail_product; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.product_detail
    ADD CONSTRAINT fk_option_detail_product FOREIGN KEY (product_id) REFERENCES bean_cafe.product_main(id) ON UPDATE CASCADE NOT VALID;


--
-- TOC entry 2107 (class 2606 OID 25122)
-- Name: product_option fk_option_product; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.product_option
    ADD CONSTRAINT fk_option_product FOREIGN KEY (product_id) REFERENCES bean_cafe.product_main(id) ON UPDATE CASCADE;


--
-- TOC entry 2101 (class 2606 OID 25127)
-- Name: order_delivery fk_order_deliver_main; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.order_delivery
    ADD CONSTRAINT fk_order_deliver_main FOREIGN KEY (order_id) REFERENCES bean_cafe.order_main(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2103 (class 2606 OID 25132)
-- Name: order_product fk_order_product_main; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.order_product
    ADD CONSTRAINT fk_order_product_main FOREIGN KEY (order_id) REFERENCES bean_cafe.order_main(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2102 (class 2606 OID 25137)
-- Name: order_main fk_order_user; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.order_main
    ADD CONSTRAINT fk_order_user FOREIGN KEY (user_nm) REFERENCES bean_cafe.user_main(user_nm) ON UPDATE CASCADE;


--
-- TOC entry 2105 (class 2606 OID 25142)
-- Name: product_main fk_product_category; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.product_main
    ADD CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES bean_cafe.category(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2106 (class 2606 OID 25147)
-- Name: product_main fk_product_users; Type: FK CONSTRAINT; Schema: bean_cafe; Owner: bean_cafe_dev
--

ALTER TABLE ONLY bean_cafe.product_main
    ADD CONSTRAINT fk_product_users FOREIGN KEY (seller_nm) REFERENCES bean_cafe.user_main(user_nm) ON UPDATE CASCADE ON DELETE SET NULL;


-- Completed on 2020-11-15 10:22:05 UTC

--
-- PostgreSQL database dump complete
--
