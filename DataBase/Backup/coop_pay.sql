--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id character varying NOT NULL,
    name character varying NOT NULL,
    image text
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    state_id integer NOT NULL
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companies (
    id character varying NOT NULL,
    cpf_cnpj character varying(18),
    ie character varying(14),
    ie_st character varying(14),
    im character varying(15),
    name character varying(60),
    fantasy character varying(60),
    public_place character varying(60),
    number character varying(60),
    complement character varying(60),
    neighborhood character varying(60),
    city_id integer NOT NULL,
    phone character varying(14),
    crt character varying(1),
    email character varying,
    duo_date date,
    is_active boolean DEFAULT true NOT NULL,
    is_block boolean,
    zip_code character varying(9),
    is_verify boolean,
    is_use_category boolean DEFAULT true NOT NULL,
    is_use_comanda_mesa boolean DEFAULT false NOT NULL,
    quantity_table integer DEFAULT 20 NOT NULL
);


ALTER TABLE public.companies OWNER TO postgres;

--
-- Name: COLUMN companies.crt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.companies.crt IS '1 = Simples Nacional.

2 = Simples Nacional, excesso sublimite de receita bruta.

3 = Regime Normal.';


--
-- Name: COLUMN companies.duo_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.companies.duo_date IS 'Data de vencimento atual / Data do bloqueio';


--
-- Name: COLUMN companies.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.companies.is_active IS 'Empresa Ativada/Inativada
Criação de empresa
Padrão False
Ele vai ser usado no processo de Invoice';


--
-- Name: COLUMN companies.is_block; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.companies.is_block IS 'Bloqueado por falta de pagamento';


--
-- Name: COLUMN companies.is_verify; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.companies.is_verify IS 'Esse campo vai ser usado para verificação de criação da empresa';


--
-- Name: COLUMN companies.is_use_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.companies.is_use_category IS 'Identifica se essa empresa usa categoria ou não';


--
-- Name: COLUMN companies.is_use_comanda_mesa; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.companies.is_use_comanda_mesa IS 'Identifica se o cliente usa comanda ou mesa';


--
-- Name: company_user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_user_role (
    id character varying NOT NULL,
    user_id character varying NOT NULL,
    company_id character varying NOT NULL,
    role_id character varying NOT NULL
);


ALTER TABLE public.company_user_role OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id character varying NOT NULL,
    cpf_cnpj character varying(18),
    ie character varying(14),
    type_of_taxpayer integer,
    name character varying(60),
    fantasy character varying(60),
    public_place character varying(60),
    number character varying(60),
    complement character varying(60),
    neighborhood character varying(60),
    city_id integer NOT NULL,
    phone character varying(14),
    email character varying,
    is_active boolean DEFAULT true NOT NULL,
    zip_code character varying(9),
    company_id character varying NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: COLUMN customers.type_of_taxpayer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.customers.type_of_taxpayer IS '1 - Contribuinte ICMS 
2 - Contribuinte Isento
9 - Não Contribuinte';


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoices (
    id character varying,
    company_id character varying,
    duo_date date,
    status character varying
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- Name: COLUMN invoices.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.invoices.status IS 'AGUARDANDO PAGAMENTO
PAGO
CANCELADO';


--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    id character varying NOT NULL,
    company_id character varying NOT NULL,
    user_id character varying NOT NULL,
    customer_id character varying NOT NULL,
    type_order integer NOT NULL,
    cpf_cnpj character varying(18),
    addition double precision DEFAULT 0,
    discount double precision DEFAULT 0,
    troco double precision DEFAULT 0,
    subtotal double precision DEFAULT 0,
    total double precision DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    user_cashier character varying,
    status character varying,
    comanda integer,
    mesa integer,
    nome_cliente character varying
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: order_itens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_itens (
    id character varying NOT NULL,
    number_item integer NOT NULL,
    order_id character varying NOT NULL,
    product_id character varying NOT NULL,
    amount double precision DEFAULT 0,
    discount_value double precision DEFAULT 0,
    discount_percentage double precision DEFAULT 0,
    cfop character varying,
    origin character varying,
    csosn_cst character varying,
    cst_pis character varying,
    ppis double precision DEFAULT 0,
    vpis double precision DEFAULT 0,
    cst_cofins character varying,
    pcofins double precision DEFAULT 0,
    vcofins double precision DEFAULT 0,
    subtotal double precision DEFAULT 0,
    total double precision DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    observation character varying,
    user_id character varying,
    comanda integer DEFAULT 0 NOT NULL,
    descricao character varying
);


ALTER TABLE public.order_itens OWNER TO postgres;

--
-- Name: order_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_payment (
    id character varying NOT NULL,
    order_id character varying NOT NULL,
    payment_id character varying NOT NULL,
    nsu character varying NOT NULL,
    autorization_code character varying,
    date_time_autorization timestamp without time zone,
    flag character varying,
    amount_paid double precision DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.order_payment OWNER TO postgres;

--
-- Name: permission_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permission_role (
    id character varying NOT NULL,
    permission_id character varying NOT NULL,
    role_id character varying NOT NULL
);


ALTER TABLE public.permission_role OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id character varying NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(200) NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: pos_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_payments (
    id character varying NOT NULL,
    payment_id integer NOT NULL,
    description_pos character varying,
    description character varying,
    name_pos character varying
);


ALTER TABLE public.pos_payments OWNER TO postgres;

--
-- Name: COLUMN pos_payments.payment_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pos_payments.payment_id IS 'Esse campo vai ser referente ao code -> types_of_payments';


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id character varying NOT NULL,
    unity_id character varying NOT NULL,
    category_id character varying,
    tax_id character varying NOT NULL,
    description character varying NOT NULL,
    barcode character varying(15),
    price_cost double precision DEFAULT 0 NOT NULL,
    sale_price double precision DEFAULT 0 NOT NULL,
    profit_margin double precision DEFAULT 0 NOT NULL,
    stock_quantity double precision DEFAULT 0 NOT NULL,
    minimum_stock double precision DEFAULT 0 NOT NULL,
    ncm character varying(8),
    cest character varying(8),
    active boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image character varying,
    change_price boolean DEFAULT false NOT NULL,
    declare_pis_cofins boolean DEFAULT false NOT NULL,
    company_id character varying NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id character varying NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: states; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.states (
    id integer NOT NULL,
    name character varying(60) NOT NULL,
    uf character varying(2) NOT NULL
);


ALTER TABLE public.states OWNER TO postgres;

--
-- Name: tax_model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_model (
    id character varying NOT NULL,
    description character varying NOT NULL,
    origin character varying,
    csosn_cst character varying,
    cst_pis character varying,
    ppis character varying,
    cst_cofins character varying,
    pcofins character varying,
    internal_cfop character varying,
    external_cfop character varying,
    active boolean NOT NULL
);


ALTER TABLE public.tax_model OWNER TO postgres;

--
-- Name: types_of_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types_of_payments (
    id character varying NOT NULL,
    description character varying NOT NULL,
    code integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    generates_installment boolean DEFAULT false,
    is_tef boolean DEFAULT false NOT NULL,
    company_id character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.types_of_payments OWNER TO postgres;

--
-- Name: unities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unities (
    id character varying NOT NULL,
    description character varying,
    sigra character varying,
    active boolean
);


ALTER TABLE public.unities OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id character varying NOT NULL,
    name character varying,
    email character varying,
    password character varying,
    active boolean DEFAULT true,
    type_user character varying(1) DEFAULT 'U'::character varying NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, image) FROM stdin;
C9222981422B4C959694C02FFCE54AA6	Lanche	https://s3.autorizadabr.com.br/storage/images/ff7483e0-ede2-44cb-a2ec-7a38724cccbd.png
13194AE1FB1B42FE9B76F7D2F804049C	Pizza	https://s3.autorizadabr.com.br/storage/images/98145cfa-9164-46c6-ad69-1f9015a904fa.png
36EC227B85BD4771A4210901AD397E06	Cosmeticos	https://s3.autorizadabr.com.br/storage/images/e1221a10-b566-4e8d-9cff-609a3423097c.png
FD7DC0132FF94B13A93B7EC93FE3EECF	Produtos de higiene	https://s3.autorizadabr.com.br/storage/images/e1221a10-b566-4e8d-9cff-609a3423097c.png
760A42990DB548DABA18EF512A0CA40A	Cachorro Quente	https://s3.autorizadabr.com.br/storage/images/e1221a10-b566-4e8d-9cff-609a3423097c.png
CE4FD726D10B4DBD93F9CCBB855372EF	Bebidas	https://s3.autorizadabr.com.br/storage/images/e1221a10-b566-4e8d-9cff-609a3423097c.png
AD430B13D1894F829242D5DA353CB366	Doces	https://s3.autorizadabr.com.br/storage/images/e1221a10-b566-4e8d-9cff-609a3423097c.png
\.


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (id, name, state_id) FROM stdin;
3550308	São Paulo	35
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.companies (id, cpf_cnpj, ie, ie_st, im, name, fantasy, public_place, number, complement, neighborhood, city_id, phone, crt, email, duo_date, is_active, is_block, zip_code, is_verify, is_use_category, is_use_comanda_mesa, quantity_table) FROM stdin;
8A719E0C76DD43A6966753B458E8E2E0	33041260065290	000000000			GRUPO CASAS BAHIA S.A.	GRUPO CASAS BAHIA S.A.	Avenida Dra Ruth Cardoso	8501		Pinheiros	3550308	0000000000	3	gabriel.developer.santos@gmail.com	2024-07-31	t	f	05425070	t	t	f	20
\.


--
-- Data for Name: company_user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company_user_role (id, user_id, company_id, role_id) FROM stdin;
81DE35909E8246C696FAECA8932C3681	06FC0568E06C438CB92064B39C22A588	8A719E0C76DD43A6966753B458E8E2E0	39A9844111CB4775BD6CCEC8966A53KO
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, cpf_cnpj, ie, type_of_taxpayer, name, fantasy, public_place, number, complement, neighborhood, city_id, phone, email, is_active, zip_code, company_id, created_at) FROM stdin;
5A6820B57E454E27A01A18D8066139AE	00000000000	00000	1	CONSUMIDOR	CONSUMIDOR	PADRÃO	SN		PADRÃO	3550308			t	05425070	8A719E0C76DD43A6966753B458E8E2E0	\N
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (id, company_id, duo_date, status) FROM stdin;
76C62039E6284253ABAD0EAD6AAC096E	9B50EA19DE2441FAB2979BDC5950F57C	2024-06-30	AGUARDANDO PAGAMENTO
F24DAD6F72E64F1B8463531A4AB73CD9	9B50EA19DE2441FAB2979BDC5950F57C	2025-01-30	AGUARDANDO PAGAMENTO
C4DCA907CE5D4E04BDADCF6F310AF1DC	9B50EA19DE2441FAB2979BDC5950F57C	2024-02-29	AGUARDANDO PAGAMENTO
76C62039E6284253ABAD0EAD6AAC096E	9B50EA19DE2441FAB2979BDC5950F57C	2024-06-30	AGUARDANDO PAGAMENTO
F24DAD6F72E64F1B8463531A4AB73CD9	9B50EA19DE2441FAB2979BDC5950F57C	2025-01-30	AGUARDANDO PAGAMENTO
C4DCA907CE5D4E04BDADCF6F310AF1DC	9B50EA19DE2441FAB2979BDC5950F57C	2024-02-29	AGUARDANDO PAGAMENTO
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."order" (id, company_id, user_id, customer_id, type_order, cpf_cnpj, addition, discount, troco, subtotal, total, created_at, updated_at, user_cashier, status, comanda, mesa, nome_cliente) FROM stdin;
\.


--
-- Data for Name: order_itens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_itens (id, number_item, order_id, product_id, amount, discount_value, discount_percentage, cfop, origin, csosn_cst, cst_pis, ppis, vpis, cst_cofins, pcofins, vcofins, subtotal, total, created_at, updated_at, observation, user_id, comanda, descricao) FROM stdin;
\.


--
-- Data for Name: order_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_payment (id, order_id, payment_id, nsu, autorization_code, date_time_autorization, flag, amount_paid, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: permission_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permission_role (id, permission_id, role_id) FROM stdin;
E3A981A276C441F496161288D62AF896	DA6E66D9393342EDA3ACF8F6DF10AF4C	39A9844111CB4775BD6CCEC8966A53KO
B7B80D3DFE284F198E7E2257D11D0B90	14D9A8B2ED7D4CD5B19EDB963331DC18	39A9844111CB4775BD6CCEC8966A53KO
5973F8DB08AD410585550710526F164F	49318E373621419EB2EF483F0587769B	39A9844111CB4775BD6CCEC8966A53KO
82EFF0AC58064D3A8EAAEEB0BD2D5674	9EB119108A194FF1BB48C7E56D5291FF	39A9844111CB4775BD6CCEC8966A53KO
BC880808B9AB4CB0B1BAB26FF398AC8E	0322380ACE3147C39E5C568207ADA6AD	39A9844111CB4775BD6CCEC8966A53KO
49BA69B602D4404BBB03850DFD094069	1F457D22C3D84B04B16A4011ABBEF774	39A9844111CB4775BD6CCEC8966A53KO
35515050054541FCB465BBC4ED31CD1F	4B091EFD06FD489A9C700312C35A88C2	39A9844111CB4775BD6CCEC8966A53KO
FBE1E990294149A2BE5AE1585F12C3A8	67DF7ED13D9A4E3E980C7059C29C023D	39A9844111CB4775BD6CCEC8966A53KO
8D402512ED1E435180D35116D29416E6	50F170C7435448BA875A2ED94E26DDA2	39A9844111CB4775BD6CCEC8966A53KO
62B1A070B65049F087512CBC4A5ADE44	9675243CEF1E4073BDF684ED59AED61D	39A9844111CB4775BD6CCEC8966A53KO
09CE4FCBD07D40978B2387B14FD94A35	CFA6D3358A6E43D79E30CA70FADD9E06	39A9844111CB4775BD6CCEC8966A53KO
8EB19AC91FD4428898DE835AC4E6CD1E	EDB6B785C15B4C40BD9547953D925F47	39A9844111CB4775BD6CCEC8966A53KO
23BAEA3397534C53AD2C374B488EDD69	0DAEDEAE1CF54DF28177A04D058567A1	39A9844111CB4775BD6CCEC8966A53KO
DCE7C812469E45DCAD8E20D18895D6A1	E71D08F765384760A9F1E6870BACB293	39A9844111CB4775BD6CCEC8966A53KO
9034678BF5CC4E449619FF44DDFEAE20	E38756B21BEE42099A8022ADACA3A1F7	39A9844111CB4775BD6CCEC8966A53KO
4705DCC8615549D1B82FD9474740499D	C7A95547B8434D56A87267B0F8BA847C	39A9844111CB4775BD6CCEC8966A53KO
BC6D09A0DCD64519A6FC90E8E72FE088	83EF58501BC045A28481E86CE5F174EC	39A9844111CB4775BD6CCEC8966A53KO
76057F71DFE34E3C991B4B4096210F1E	746A095D6FA5416C9E9953EB51431CE8	39A9844111CB4775BD6CCEC8966A53KO
F0F43BA9A1D74BE09DF99BCA05B0BDAE	646D4B1EEADD4309B430F1B507F40C4A	39A9844111CB4775BD6CCEC8966A53KO
F3675110FBB04820B1C58E431355B993	5271C1798C7A49C4B7B21CD52E04E9C1	39A9844111CB4775BD6CCEC8966A53KO
3192A51268624A8FB64217F821C559EB	557997D9FFFB42859E6DEE1516B7FAED	39A9844111CB4775BD6CCEC8966A53KO
2256E84311BC48BBA05F930110F6BF29	7F8678CECAFF4C78983DEA2623F051A4	39A9844111CB4775BD6CCEC8966A53KO
311EA6B75DD14B26993F458E1539CFE4	7472E5856670466DB4B19D5D83A49627	39A9844111CB4775BD6CCEC8966A53KO
1BF38BD54107426792329221A1C4A93F	84EA5941B52F40EDABB5988B88877B03	39A9844111CB4775BD6CCEC8966A53KO
BC800EACDA6646AEAAC9E466A9CEDA28	C77006C7B9CB45A4850D7B38ED6C16D8	39A9844111CB4775BD6CCEC8966A53KO
007B5F35E9F740D2890E1CFF5C5033E8	815112D511FE4A038D4C1E2BDB2281B7	39A9844111CB4775BD6CCEC8966A53KO
4CC19D861D44430682925B64364AB53C	05C5A265ED4C4248A31EF104FF2766BB	39A9844111CB4775BD6CCEC8966A53KO
13CA9BFBE7D249248C37155762847BCC	7920E09C59984D07B329C03F98815943	39A9844111CB4775BD6CCEC8966A53KO
9F1C5438F9324EB59056F1570424A0C4	86B1CFD0B9904AE4BA432E46E835C5E6	39A9844111CB4775BD6CCEC8966A53KO
AEEC9DC4D03A419CA7A64E253D2C97D0	4621B5E7BEC444BB8403C80D2B280458	39A9844111CB4775BD6CCEC8966A53KO
91F0D34BFE9444C7A1265DC9DDF77F07	7CF89923E082434498F34F8F96DE8954	39A9844111CB4775BD6CCEC8966A53KO
1FA94479C54F433797AF16A3C1B1D647	440FD697ACF44674BC514BA8946ED56E	39A9844111CB4775BD6CCEC8966A53KO
07D7F0F24B6549859074DF51086587D6	5126673C6C104790B40C1CC15BFC7B7A	39A9844111CB4775BD6CCEC8966A53KO
DE6F07EBFDD549428570FF68EE0A30CF	F8219A2B88B74FD796E22EF922F010B6	39A9844111CB4775BD6CCEC8966A53KO
BF6015114B2C4AAF81EA593C2BD48FD6	C51EB07E58B2497597DAAB59E08AE743	39A9844111CB4775BD6CCEC8966A53KO
19A70BE4814A4BD389C03C8C5A90C8F9	7C0716F34E4D43018BC2901072A31C75	39A9844111CB4775BD6CCEC8966A53KO
166747A97E444D369DE1201CC37CA156	2F419CE10AA7496BAABC49AE97E051C5	39A9844111CB4775BD6CCEC8966A53KO
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name, description) FROM stdin;
258AE3F75CA44760A23AFAA8B8174F12	company-user-role.put	Permite alterar registro
19AB4558A7084D5BBDD1F7144BCE1A2F	category.put	Permite alterar registro
84EA5941B52F40EDABB5988B88877B03	customer.put	Permite alterar registro
C77006C7B9CB45A4850D7B38ED6C16D8	product.delete	Permite deletar registro
815112D511FE4A038D4C1E2BDB2281B7	product.get	Permite consultar registro
05C5A265ED4C4248A31EF104FF2766BB	product.post	Permite gravar
7920E09C59984D07B329C03F98815943	product.put	Permite alterar registro
9EF1F17AEA4145F6B64E7D9CCD7FB6BF	unit.put	Permite alterar registro
EDB6B785C15B4C40BD9547953D925F47	user.put	Permite alterar registro
DA6E66D9393342EDA3ACF8F6DF10AF4C	order.delete	Permite deletar registro
14D9A8B2ED7D4CD5B19EDB963331DC18	order.get	Permite consultar registro
49318E373621419EB2EF483F0587769B	order.post	Permite gravar
9EB119108A194FF1BB48C7E56D5291FF	order.put	Permite alterar registro
0322380ACE3147C39E5C568207ADA6AD	order-itens.delete	Permite deletar registro
1F457D22C3D84B04B16A4011ABBEF774	order-itens.get	Permite consultar registro
67DF7ED13D9A4E3E980C7059C29C023D	company.delete	Permite deletar registro
50F170C7435448BA875A2ED94E26DDA2	company.update	Permite alterar registro
4B091EFD06FD489A9C700312C35A88C2	order-itens.post	Permite gravar
9675243CEF1E4073BDF684ED59AED61D	company.post	Permite gravar
CFA6D3358A6E43D79E30CA70FADD9E06	user.delete	Permite deletar registro
0DAEDEAE1CF54DF28177A04D058567A1	user.post	Permite gravar
E71D08F765384760A9F1E6870BACB293	user.get	Permite consultar registro
E38756B21BEE42099A8022ADACA3A1F7	company.get	Permite consultar registro
C7A95547B8434D56A87267B0F8BA847C	city.get	Permite alterar registro
646D4B1EEADD4309B430F1B507F40C4A	city.put	Permite alterar registro
83EF58501BC045A28481E86CE5F174EC	city.post	Permite alterar registro
5271C1798C7A49C4B7B21CD52E04E9C1	city.delete	Permite alterar registro
C8B1D1967D3A476DB8873CC5964329E3	state.delete	Permite alterar registro
DEC12B0A764442E1908AB9F350361393	state.get	Permite alterar registro
B59DAB10EBEB4656883FCAC32BEAC1A0	state.post	Permite alterar registro
4F8869D346554D3EB6255F5B071BA53B	state.put	Permite alterar registro
F7EB2E78EED64B128609D3FCC60539BA	role.post	Permite alterar registro
F7F0E23591E34DC0A994AB18C86E2163	role.put	Permite alterar registro
D49EFA1818DD4950A4D0A3471FF2B636	role.delete	Permite alterar registro
AC28EFB9B0924D749D1450AE13750BBE	permission.delete	Permite alterar registro
ED8A930584C641AAB39909BE2EF9147F	permission.post	Permite alterar registro
4306DFF71D414101B6700360AA22BF26	permission.put	Permite alterar registro
746A095D6FA5416C9E9953EB51431CE8	permission.get	Permite alterar registro
6D98B29EAC4D4421A634506093472FCB	role.get	Permite alterar registro
CBA42637968D45258A7DDADCD8AB7951	permission-role.get	Permite alterar registro
7EC82CEE735B4982BE7667FF8CBE3379	permission-role.post	Permite alterar registro
6870CF5CF23149828CBDA4DC64ED94E5	permission-role.put	Permite alterar registro
FC0B7785B11B4E54A443DE4BF5FB0996	permission-role.delete	Permite alterar registro
928B04E439544BBD888310F9BBCF9E1E	company-user-role.delete	Permite alterar registro
B506D0426F9E4205978736D1B28F22B1	company-user-role.post	Permite alterar registro
7C15CC5453DF43F8B98C2BEE5A6D4ACD	company-user-role.get	Permite alterar registro
3914DFB6258C4FF58151EAD6CA77D9B7	category.delete	Permite deletar registro
A799114F85544999B9546837CC2DA819	category.get	Permite consultar registro
C7FE51CF26D948E6B4F848D50E6B361B	category.post	Permite gravar
86B1CFD0B9904AE4BA432E46E835C5E6	order-itens.put	Permite alterar registro
08F59377175D4F708E5350BCC19907E4	unit.delete	Permite deletar registro
6334928841974D02A2CA4FB9BE9392F0	unit.get	Permite consultar registro
B72EC881A53D49A89D9EF0D22676CEBA	unit.post	Permite gravar
557997D9FFFB42859E6DEE1516B7FAED	customer.delete	Permite deletar registro
7F8678CECAFF4C78983DEA2623F051A4	customer.get	Permite consultar registro
7472E5856670466DB4B19D5D83A49627	customer.post	Permite gravar
4621B5E7BEC444BB8403C80D2B280458	type-of-payment.delete	Permite deletar registro
7CF89923E082434498F34F8F96DE8954	type-of-payment.get	Permite consultar registro
440FD697ACF44674BC514BA8946ED56E	type-of-payment.post	Permite gravar
5126673C6C104790B40C1CC15BFC7B7A	type-of-payment.put	Permite alterar registro
F8219A2B88B74FD796E22EF922F010B6	order-payment.delete	Permite deletar registro
C51EB07E58B2497597DAAB59E08AE743	order-payment.get	Permite consultar registro
7C0716F34E4D43018BC2901072A31C75	order-payment.post	Permite gravar
2F419CE10AA7496BAABC49AE97E051C5	order-payment.put	Permite alterar registro
\.


--
-- Data for Name: pos_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_payments (id, payment_id, description_pos, description, name_pos) FROM stdin;
93F19ADA517147458FFB52BBA77F773E	3	CREDITO	Crédito	STONE
B6698CE05BDF4DDB9AAC4D3394A3F1F6	4	DEBITO	Débito	STONE
CF83E638D1984D4E92C5EC16AA8D4FD8	6	VOUCHER	Voucher	STONE
95959E58DFB44495A1BC84BC7C5C036F	13	PIX	Pix	STONE | CIELO
FF3A54C70CC040D6BE82B6C0A4AC1D9D	4	DEBITO_AVISTA	Debito Avista	CIELO
3829939C3ECE4E198E2E9ECE74AB2AB3	3	CREDITO_AVISTA	Credito Ávista	CIELO
28265DAF12164774B2C6D2448ADDE8B9	3	CREDITO_PARCELADO_LOJA	Crédito Parcelado Loja	CIELO
B08B1856EF7448ADA274E34583217C6D	3	CREDITO_PARCELADO_CLIENTE	Crédito Parcelado Cliente	CIELO
2AF1504F69AF4E72A40F4419DBEBCAC6	6	VOUCHER_ALIMENTACAO	Coucher Alimentação	CIELO
8D3DE551735B47DF92299B7DF944FEF2	7	VOUCHER_REFEICAO	Voucher Refeição	CIELO
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, unity_id, category_id, tax_id, description, barcode, price_cost, sale_price, profit_margin, stock_quantity, minimum_stock, ncm, cest, active, created_at, updated_at, image, change_price, declare_pis_cofins, company_id) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
39A9844111CB4775BD6CCEC8966A531D	Regra Emp
39A9844111CB4775BD6CCEC8966A53KO	Master
39A98441B6774775BD6CCEC8966A53KO	Root
\.


--
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.states (id, name, uf) FROM stdin;
35	São Paulo	SP
\.


--
-- Data for Name: tax_model; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_model (id, description, origin, csosn_cst, cst_pis, ppis, cst_cofins, pcofins, internal_cfop, external_cfop, active) FROM stdin;
436D61C0D22C4E9B90038CF3AA6F0296	Regra Fiscal 01	100	103	52	0,65	56	0,03	6108	5949	t
BF0312E6D7064B82ADE78B0118795341	Regra Fiscal 02	100	103	52	0,65	56	0,03	6108	5949	t
008DB6DCA9314F1E92FC3888E9FEE42C	Regra Fiscal 03	100	103	52	0,65	56	0,03	6108	5949	t
67EB00C3AF094B97BC9962694E254B2D	Regra Fiscal 04	100	103	52	0,65	56	0,03	6108	5949	t
B94FD0C2E5DB4343B88FF4342FD8EAE9	Regra Fiscal 05	100	103	52	0,65	56	0,03	6108	5949	t
029FB1F711D3447CB75ADF74F59D07C9	Regra Fiscal 06	100	103	52	0,65	56	0,03	6108	5949	t
\.


--
-- Data for Name: types_of_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types_of_payments (id, description, code, active, generates_installment, is_tef, company_id, created_at, updated_at) FROM stdin;
E7B6B01ED2934AEA8DC01E65FFEDECFC	Cartão de Débito	4	t	f	f	8A719E0C76DD43A6966753B458E8E2E0	\N	\N
EB6E91BA8EE249C39553D0ED5C311E73	Pagamento Instantâneo (PIX) - Estático	20	t	f	f	8A719E0C76DD43A6966753B458E8E2E0	\N	\N
CAE269B65A9042F982721E10779EB6DD	Dinheiro	1	t	f	f	8A719E0C76DD43A6966753B458E8E2E0	\N	\N
3CA8CB43257842DA8869DCED482B9982	Pagamento Instantâneo (PIX) - Dinâmico	17	t	f	f	8A719E0C76DD43A6966753B458E8E2E0	\N	\N
2F26BEBAB98B4974ABA79B10759ADFEF	Cartão de Crédito	3	t	f	f	8A719E0C76DD43A6966753B458E8E2E0	\N	\N
\.


--
-- Data for Name: unities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unities (id, description, sigra, active) FROM stdin;
48D7D3208C0244A6A683619C7A7C8D58	Unidade Medida	sigra	t
CB5A5349C72C4D8CA6518F91E8A20DE5	Unidade Medida 2	sigra	t
B782AE0E5C584867A3B3ECA105B39719	Unidade Medida 3	sigra	t
BF6A5060EA804B44944E9BAC8AA3EF17	Unidade Medida 4	sigra	t
9B5648C345D44C2A94F2586C2766E457	Unidade Medida 5	Aaa	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, active, type_user) FROM stdin;
06FC0568E06C438CB92064B39C22A588	Coop Pay	cooppay@autorizadabr.com	$2a$10$UCWiDDkbcJeIb3xW5lwjeumyEu1wjh3KcejfrGvuc7eC/1m2RRmI2	t	U
\.


--
-- Name: categories categories_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pk PRIMARY KEY (id);


--
-- Name: cities cities_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pk PRIMARY KEY (id);


--
-- Name: companies companies_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pk PRIMARY KEY (id);


--
-- Name: company_user_role company_user_role_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_user_role
    ADD CONSTRAINT company_user_role_pk PRIMARY KEY (id);


--
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- Name: order_itens order_itens_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_itens
    ADD CONSTRAINT order_itens_pk PRIMARY KEY (id);


--
-- Name: order_payment order_payment_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payment
    ADD CONSTRAINT order_payment_pk PRIMARY KEY (id);


--
-- Name: order order_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pk PRIMARY KEY (id);


--
-- Name: permission_role permission_role_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permission_role
    ADD CONSTRAINT permission_role_pk PRIMARY KEY (id);


--
-- Name: permissions permissions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pk PRIMARY KEY (id);


--
-- Name: pos_payments pos_payments_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_payments
    ADD CONSTRAINT pos_payments_pk PRIMARY KEY (id);


--
-- Name: products products_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pk PRIMARY KEY (id);


--
-- Name: roles roles_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (id);


--
-- Name: states states_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pk PRIMARY KEY (id);


--
-- Name: tax_model tax_model_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_model
    ADD CONSTRAINT tax_model_pk PRIMARY KEY (id);


--
-- Name: types_of_payments types_of_payments_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_of_payments
    ADD CONSTRAINT types_of_payments_pk PRIMARY KEY (id);


--
-- Name: unities unities_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unities
    ADD CONSTRAINT unities_pk PRIMARY KEY (id);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (id);


--
-- Name: users users_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_un UNIQUE (email);


--
-- Name: companies companies_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_fk FOREIGN KEY (city_id) REFERENCES public.cities(id) ON DELETE CASCADE;


--
-- Name: company_user_role company_user_role_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_user_role
    ADD CONSTRAINT company_user_role_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: company_user_role company_user_role_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_user_role
    ADD CONSTRAINT company_user_role_fk_1 FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_user_role company_user_role_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_user_role
    ADD CONSTRAINT company_user_role_fk_2 FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: customers customers_fk_cities; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_fk_cities FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: customers customers_fk_companies; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_fk_companies FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: order order_fk_companies; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_fk_companies FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: order order_fk_customers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_fk_customers FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: order order_fk_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_fk_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: order_itens order_itens_fk_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_itens
    ADD CONSTRAINT order_itens_fk_order FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: order_itens order_itens_fk_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_itens
    ADD CONSTRAINT order_itens_fk_products FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: order_payment order_payment_fk_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payment
    ADD CONSTRAINT order_payment_fk_order FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: order_payment order_payment_fk_type_of_payment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payment
    ADD CONSTRAINT order_payment_fk_type_of_payment FOREIGN KEY (payment_id) REFERENCES public.types_of_payments(id);


--
-- Name: permission_role permission_role_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permission_role
    ADD CONSTRAINT permission_role_fk FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: permission_role permission_role_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permission_role
    ADD CONSTRAINT permission_role_fk_1 FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: products products_fk_categories; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_fk_categories FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: products products_fk_companies; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_fk_companies FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: products products_fk_tax_model; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_fk_tax_model FOREIGN KEY (tax_id) REFERENCES public.tax_model(id);


--
-- Name: products products_fk_unities; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_fk_unities FOREIGN KEY (unity_id) REFERENCES public.unities(id);


--
-- Name: types_of_payments types_of_payments_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_of_payments
    ADD CONSTRAINT types_of_payments_fk FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- PostgreSQL database dump complete
--

