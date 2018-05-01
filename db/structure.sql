--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.13
-- Dumped by pg_dump version 9.6.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: belepoigenyles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.belepoigenyles (
    id bigint NOT NULL,
    belepo_tipus character varying(255),
    szoveges_ertekeles text,
    ertekeles_id bigint NOT NULL,
    usr_id bigint
);


SET default_with_oids = false;

--
-- Name: eredmeny_tmp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eredmeny_tmp (
    uid bigint,
    pont integer
);


SET default_with_oids = true;

--
-- Name: ertekeles_uzenet; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ertekeles_uzenet (
    id bigint NOT NULL,
    feladas_ido timestamp without time zone,
    uzenet text,
    felado_usr_id bigint,
    group_id bigint,
    semester character varying(9) NOT NULL,
    from_system boolean DEFAULT false
);


--
-- Name: ertekelesek; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ertekelesek (
    id bigint NOT NULL,
    belepoigeny_statusz character varying(255),
    feladas timestamp without time zone,
    pontigeny_statusz character varying(255),
    semester character varying(9) NOT NULL,
    szoveges_ertekeles text NOT NULL,
    utolso_elbiralas timestamp without time zone,
    utolso_modositas timestamp without time zone,
    elbiralo_usr_id bigint,
    grp_id bigint,
    felado_usr_id bigint,
    pontozasi_elvek text DEFAULT ''::text NOT NULL,
    next_version bigint,
    explanation text,
    optlock integer DEFAULT 0 NOT NULL,
    is_considered boolean DEFAULT false NOT NULL
);


--
-- Name: event_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_grp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.groups_grp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    grp_id bigint DEFAULT nextval('public.groups_grp_id_seq'::regclass) NOT NULL,
    grp_name text NOT NULL,
    grp_type character varying(20) NOT NULL,
    grp_parent bigint,
    grp_state character varying DEFAULT 'akt'::bpchar,
    grp_description text,
    grp_webpage character varying(64),
    grp_maillist character varying(64),
    grp_head character varying(48),
    grp_founded integer,
    grp_issvie boolean DEFAULT false NOT NULL,
    grp_svie_delegate_nr integer,
    grp_users_can_apply boolean DEFAULT true NOT NULL,
    grp_archived_members_visible boolean
);


--
-- Name: grp_members_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.grp_members_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_with_oids = false;

--
-- Name: grp_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grp_membership (
    id bigint DEFAULT nextval('public.grp_members_seq'::regclass) NOT NULL,
    grp_id bigint,
    usr_id bigint,
    membership_start date DEFAULT now(),
    membership_end date,
    archived date
);


--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: im_accounts_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.im_accounts_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: im_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.im_accounts (
    id bigint DEFAULT nextval('public.im_accounts_seq'::regclass) NOT NULL,
    protocol character varying(50) NOT NULL,
    account_name character varying(255) NOT NULL,
    usr_id bigint
);


--
-- Name: log_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.log (
    id bigint DEFAULT nextval('public.log_seq'::regclass) NOT NULL,
    grp_id bigint,
    usr_id bigint NOT NULL,
    evt_date date DEFAULT now(),
    event character varying(30) NOT NULL
);


--
-- Name: lostpw_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lostpw_tokens (
    created timestamp without time zone,
    token character varying(64),
    usr_id bigint NOT NULL
);


--
-- Name: point_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.point_details (
    id integer NOT NULL,
    principle_id integer,
    point_request_id integer,
    point integer
);


--
-- Name: point_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.point_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: point_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.point_details_id_seq OWNED BY public.point_details.id;


--
-- Name: point_history_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.point_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: point_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.point_history (
    id bigint DEFAULT nextval('public.point_history_seq'::regclass) NOT NULL,
    usr_id bigint NOT NULL,
    point integer NOT NULL,
    semester character varying(9) NOT NULL
);


--
-- Name: points_2017; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.points_2017 (
    usr_firstname text,
    usr_lastname text,
    usr_nickname text,
    usr_neptun character varying,
    usr_bme_id character varying,
    point integer
);


SET default_with_oids = true;

--
-- Name: pontigenyles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pontigenyles (
    id bigint NOT NULL,
    pont integer,
    ertekeles_id bigint NOT NULL,
    usr_id bigint
);


--
-- Name: poszt_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.poszt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_with_oids = false;

--
-- Name: poszt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poszt (
    id bigint DEFAULT nextval('public.poszt_seq'::regclass) NOT NULL,
    grp_member_id bigint,
    pttip_id bigint
);


--
-- Name: poszttipus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.poszttipus_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: poszttipus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poszttipus (
    pttip_id bigint DEFAULT nextval('public.poszttipus_seq'::regclass) NOT NULL,
    grp_id bigint,
    pttip_name character varying(30) NOT NULL,
    delegated_post boolean DEFAULT false
);


--
-- Name: principles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.principles (
    id integer NOT NULL,
    evaluation_id integer,
    name character varying,
    description character varying,
    type character varying,
    max_per_member integer
);


--
-- Name: principles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.principles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: principles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.principles_id_seq OWNED BY public.principles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: spot_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spot_images (
    usr_neptun character varying NOT NULL,
    image_path character varying(255) NOT NULL
);


--
-- Name: svie_post_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.svie_post_requests (
    id integer NOT NULL,
    member_type character varying,
    usr_id integer
);


--
-- Name: svie_post_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.svie_post_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: svie_post_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.svie_post_requests_id_seq OWNED BY public.svie_post_requests.id;


SET default_with_oids = true;

--
-- Name: system_attrs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_attrs (
    attributeid bigint NOT NULL,
    attributename character varying(255) NOT NULL,
    attributevalue character varying(255) NOT NULL
);


SET default_with_oids = false;

--
-- Name: temp_belepo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.temp_belepo (
    usr_lastname text,
    usr_firstname text,
    usr_nickname text,
    grp_name text,
    belepo_tipus character varying(255),
    szoveges_ertekeles text
);


--
-- Name: users_usr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_usr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_with_oids = true;

--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    usr_id bigint DEFAULT nextval('public.users_usr_id_seq'::regclass) NOT NULL,
    usr_email character varying(64),
    usr_neptun character varying,
    usr_firstname text NOT NULL,
    usr_lastname text NOT NULL,
    usr_nickname text,
    usr_svie_member_type character varying(255) DEFAULT 'NEMTAG'::character varying NOT NULL,
    usr_svie_primary_membership bigint,
    usr_delegated boolean DEFAULT false NOT NULL,
    usr_show_recommended_photo boolean DEFAULT false NOT NULL,
    usr_screen_name character varying(50) NOT NULL,
    usr_date_of_birth date,
    usr_gender character varying(50) DEFAULT 'NOTSPECIFIED'::character varying NOT NULL,
    usr_student_status character varying(50) DEFAULT 'UNKNOWN'::character varying NOT NULL,
    usr_mother_name character varying(100),
    usr_photo_path character varying(255),
    usr_webpage character varying(255),
    usr_cell_phone character varying(50),
    usr_home_address character varying(255),
    usr_est_grad character varying(10),
    usr_dormitory character varying(50),
    usr_room character varying(10),
    usr_status character varying(8) DEFAULT 'INACTIVE'::character varying NOT NULL,
    usr_password character varying(28),
    usr_salt character varying(12),
    usr_lastlogin timestamp without time zone,
    usr_auth_sch_id character varying,
    usr_bme_id character varying,
    usr_created_at timestamp without time zone,
    usr_metascore integer
);


--
-- Name: usr_private_attrs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usr_private_attrs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_with_oids = false;

--
-- Name: usr_private_attrs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usr_private_attrs (
    id bigint DEFAULT nextval('public.usr_private_attrs_id_seq'::regclass) NOT NULL,
    usr_id bigint NOT NULL,
    attr_name character varying(64) NOT NULL,
    visible boolean DEFAULT false NOT NULL
);


--
-- Name: point_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_details ALTER COLUMN id SET DEFAULT nextval('public.point_details_id_seq'::regclass);


--
-- Name: principles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principles ALTER COLUMN id SET DEFAULT nextval('public.principles_id_seq'::regclass);


--
-- Name: svie_post_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.svie_post_requests ALTER COLUMN id SET DEFAULT nextval('public.svie_post_requests_id_seq'::regclass);


--
-- Name: belepoigenyles belepoigenyles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.belepoigenyles
    ADD CONSTRAINT belepoigenyles_pkey PRIMARY KEY (id);


--
-- Name: ertekeles_uzenet ertekeles_uzenet_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ertekeles_uzenet
    ADD CONSTRAINT ertekeles_uzenet_pkey PRIMARY KEY (id);


--
-- Name: ertekelesek ertekelesek_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ertekelesek
    ADD CONSTRAINT ertekelesek_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (grp_id);


--
-- Name: grp_membership grp_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grp_membership
    ADD CONSTRAINT grp_membership_pkey PRIMARY KEY (id);


--
-- Name: im_accounts im_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.im_accounts
    ADD CONSTRAINT im_accounts_pkey PRIMARY KEY (id);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id);


--
-- Name: lostpw_tokens lostpw_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lostpw_tokens
    ADD CONSTRAINT lostpw_tokens_pkey PRIMARY KEY (usr_id);


--
-- Name: lostpw_tokens lostpw_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lostpw_tokens
    ADD CONSTRAINT lostpw_tokens_token_key UNIQUE (token);


--
-- Name: point_details point_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_details
    ADD CONSTRAINT point_details_pkey PRIMARY KEY (id);


--
-- Name: point_history point_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_history
    ADD CONSTRAINT point_history_pkey PRIMARY KEY (id);


--
-- Name: pontigenyles pontigenyles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pontigenyles
    ADD CONSTRAINT pontigenyles_pkey PRIMARY KEY (id);


--
-- Name: poszt poszt_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poszt
    ADD CONSTRAINT poszt_pkey PRIMARY KEY (id);


--
-- Name: poszttipus poszttipus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poszttipus
    ADD CONSTRAINT poszttipus_pkey PRIMARY KEY (pttip_id);


--
-- Name: principles principles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principles
    ADD CONSTRAINT principles_pkey PRIMARY KEY (id);


--
-- Name: spot_images spot_images_usr_neptun_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spot_images
    ADD CONSTRAINT spot_images_usr_neptun_key UNIQUE (usr_neptun);


--
-- Name: svie_post_requests svie_post_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.svie_post_requests
    ADD CONSTRAINT svie_post_requests_pkey PRIMARY KEY (id);


--
-- Name: system_attrs system_attrs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_attrs
    ADD CONSTRAINT system_attrs_pkey PRIMARY KEY (attributeid);


--
-- Name: grp_membership unique_memberships; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grp_membership
    ADD CONSTRAINT unique_memberships UNIQUE (grp_id, usr_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (usr_id);


--
-- Name: users users_usr_auth_sch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_usr_auth_sch_id_key UNIQUE (usr_auth_sch_id);


--
-- Name: users users_usr_bme_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_usr_bme_id_key UNIQUE (usr_bme_id);


--
-- Name: users users_usr_neptun_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_usr_neptun_key UNIQUE (usr_neptun);


--
-- Name: users users_usr_screen_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_usr_screen_name_key UNIQUE (usr_screen_name);


--
-- Name: usr_private_attrs usr_private_attrs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usr_private_attrs
    ADD CONSTRAINT usr_private_attrs_pkey PRIMARY KEY (id);


--
-- Name: bel_tipus_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bel_tipus_idx ON public.belepoigenyles USING btree (belepo_tipus);


--
-- Name: ert_semester_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ert_semester_idx ON public.ertekelesek USING btree (semester);


--
-- Name: fki_felado_usr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_felado_usr_id ON public.ertekeles_uzenet USING btree (felado_usr_id);


--
-- Name: fki_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_group_id ON public.ertekeles_uzenet USING btree (group_id);


--
-- Name: groups_grp_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX groups_grp_id_idx ON public.groups USING btree (grp_id);


--
-- Name: idx_groups_grp_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_groups_grp_name ON public.groups USING btree (grp_name);


--
-- Name: idx_groups_grp_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_groups_grp_type ON public.groups USING btree (grp_type);


--
-- Name: membership_usr_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX membership_usr_fk_idx ON public.grp_membership USING btree (usr_id);


--
-- Name: next_version_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX next_version_idx ON public.ertekelesek USING btree (next_version NULLS FIRST);


--
-- Name: poszt_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poszt_fk_idx ON public.poszt USING btree (grp_member_id);


--
-- Name: unique_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_idx ON public.ertekelesek USING btree (grp_id, semester, next_version NULLS FIRST);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: users_usr_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_usr_id_idx ON public.users USING btree (usr_id);


--
-- Name: users_usr_neptun_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_usr_neptun_idx ON public.users USING btree (upper((usr_neptun)::text));


--
-- Name: users_usr_screen_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_usr_screen_name_idx ON public.users USING btree (upper((usr_screen_name)::text));


--
-- Name: groups $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT "$1" FOREIGN KEY (grp_parent) REFERENCES public.groups(grp_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: lostpw_tokens fk1e9df02e5854b081; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lostpw_tokens
    ADD CONSTRAINT fk1e9df02e5854b081 FOREIGN KEY (usr_id) REFERENCES public.users(usr_id);


--
-- Name: belepoigenyles fk4e301ac36958e716; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.belepoigenyles
    ADD CONSTRAINT fk4e301ac36958e716 FOREIGN KEY (usr_id) REFERENCES public.users(usr_id);


--
-- Name: ertekelesek fk807db18871c0d156; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ertekelesek
    ADD CONSTRAINT fk807db18871c0d156 FOREIGN KEY (felado_usr_id) REFERENCES public.users(usr_id);


--
-- Name: ertekelesek fk807db18879696582; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ertekelesek
    ADD CONSTRAINT fk807db18879696582 FOREIGN KEY (grp_id) REFERENCES public.groups(grp_id);


--
-- Name: ertekelesek fk807db188b31cf015; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ertekelesek
    ADD CONSTRAINT fk807db188b31cf015 FOREIGN KEY (elbiralo_usr_id) REFERENCES public.users(usr_id);


--
-- Name: belepoigenyles fk_ertekeles_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.belepoigenyles
    ADD CONSTRAINT fk_ertekeles_id FOREIGN KEY (ertekeles_id) REFERENCES public.ertekelesek(id) ON DELETE CASCADE;


--
-- Name: pontigenyles fk_ertekeles_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pontigenyles
    ADD CONSTRAINT fk_ertekeles_id FOREIGN KEY (ertekeles_id) REFERENCES public.ertekelesek(id) ON DELETE CASCADE;


--
-- Name: ertekeles_uzenet fk_felado_usr_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ertekeles_uzenet
    ADD CONSTRAINT fk_felado_usr_id FOREIGN KEY (felado_usr_id) REFERENCES public.users(usr_id) ON DELETE SET NULL;


--
-- Name: ertekeles_uzenet fk_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ertekeles_uzenet
    ADD CONSTRAINT fk_group_id FOREIGN KEY (group_id) REFERENCES public.groups(grp_id) ON DELETE CASCADE;


--
-- Name: ertekelesek fk_next_version; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ertekelesek
    ADD CONSTRAINT fk_next_version FOREIGN KEY (next_version) REFERENCES public.ertekelesek(id) ON DELETE SET NULL;


--
-- Name: pontigenyles fkaa1034cd6958e716; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pontigenyles
    ADD CONSTRAINT fkaa1034cd6958e716 FOREIGN KEY (usr_id) REFERENCES public.users(usr_id);


--
-- Name: grp_membership grp_membership_grp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grp_membership
    ADD CONSTRAINT grp_membership_grp_id_fkey FOREIGN KEY (grp_id) REFERENCES public.groups(grp_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: grp_membership grp_membership_usr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grp_membership
    ADD CONSTRAINT grp_membership_usr_id_fkey FOREIGN KEY (usr_id) REFERENCES public.users(usr_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: im_accounts im_accounts_usr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.im_accounts
    ADD CONSTRAINT im_accounts_usr_id_fkey FOREIGN KEY (usr_id) REFERENCES public.users(usr_id);


--
-- Name: log log_group; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_group FOREIGN KEY (grp_id) REFERENCES public.groups(grp_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: log log_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_user FOREIGN KEY (usr_id) REFERENCES public.users(usr_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: point_history point_history_usr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_history
    ADD CONSTRAINT point_history_usr_id_fkey FOREIGN KEY (usr_id) REFERENCES public.users(usr_id);


--
-- Name: poszt poszt_grp_member_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poszt
    ADD CONSTRAINT poszt_grp_member_fk FOREIGN KEY (grp_member_id) REFERENCES public.grp_membership(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: poszt poszt_pttip_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poszt
    ADD CONSTRAINT poszt_pttip_fk FOREIGN KEY (pttip_id) REFERENCES public.poszttipus(pttip_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: poszttipus poszttipus_opc_csoport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poszttipus
    ADD CONSTRAINT poszttipus_opc_csoport FOREIGN KEY (grp_id) REFERENCES public.groups(grp_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users users_main_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_main_group_fkey FOREIGN KEY (usr_svie_primary_membership) REFERENCES public.grp_membership(id);


--
-- Name: usr_private_attrs usr_private_attrs_usr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usr_private_attrs
    ADD CONSTRAINT usr_private_attrs_usr_id_fkey FOREIGN KEY (usr_id) REFERENCES public.users(usr_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20161124163851');

INSERT INTO schema_migrations (version) VALUES ('20171130184224');

INSERT INTO schema_migrations (version) VALUES ('20180315103617');

INSERT INTO schema_migrations (version) VALUES ('20180317194014');

INSERT INTO schema_migrations (version) VALUES ('20180317200507');

