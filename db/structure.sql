--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.16
-- Dumped by pg_dump version 12.1

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

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: entry_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.entry_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entry_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entry_requests (
    id bigint DEFAULT nextval('public.entry_requests_id_seq'::regclass) NOT NULL,
    entry_type character varying(255),
    justification text,
    evaluation_id bigint NOT NULL,
    user_id bigint
);


--
-- Name: eredmeny_tmp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eredmeny_tmp (
    uid bigint,
    pont integer
);


--
-- Name: evaluation_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.evaluation_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluation_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.evaluation_messages (
    id bigint DEFAULT nextval('public.evaluation_messages_id_seq'::regclass) NOT NULL,
    sent_at timestamp without time zone,
    message text,
    sender_user_id bigint,
    group_id bigint,
    semester character varying(9) NOT NULL,
    from_system boolean DEFAULT false
);


--
-- Name: evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.evaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.evaluations (
    id bigint DEFAULT nextval('public.evaluations_id_seq'::regclass) NOT NULL,
    entry_request_status character varying(255),
    "timestamp" timestamp without time zone,
    point_request_status character varying(255),
    semester character varying(9) NOT NULL,
    justification text NOT NULL,
    last_evaulation timestamp without time zone,
    last_modification timestamp without time zone,
    reviewer_user_id bigint,
    group_id bigint,
    creator_user_id bigint,
    principle text DEFAULT ''::text NOT NULL,
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
    id bigint DEFAULT nextval('public.groups_grp_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    grp_type character varying(20),
    parent_id bigint,
    state character varying DEFAULT 'akt'::bpchar,
    description text,
    webpage character varying(64),
    maillist character varying(64),
    head character varying(48),
    founded integer,
    issvie boolean DEFAULT false NOT NULL,
    delegate_count integer,
    users_can_apply boolean DEFAULT true NOT NULL,
    archived_members_visible boolean,
    type character varying
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
    name character varying(255) NOT NULL,
    user_id bigint
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
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id bigint DEFAULT nextval('public.grp_members_seq'::regclass) NOT NULL,
    group_id bigint,
    user_id bigint,
    start_date date DEFAULT now(),
    end_date date,
    archived date
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    target_type character varying NOT NULL,
    target_id integer NOT NULL,
    notifiable_type character varying NOT NULL,
    notifiable_id integer NOT NULL,
    key character varying NOT NULL,
    group_type character varying,
    group_id integer,
    group_owner_id integer,
    notifier_type character varying,
    notifier_id integer,
    parameters text,
    opened_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: point_detail_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.point_detail_comments (
    id integer NOT NULL,
    comment text,
    user_id integer,
    point_detail_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: point_detail_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.point_detail_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: point_detail_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.point_detail_comments_id_seq OWNED BY public.point_detail_comments.id;


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
-- Name: point_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.point_histories (
    id bigint DEFAULT nextval('public.point_history_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    point integer NOT NULL,
    semester character varying(9) NOT NULL
);


--
-- Name: point_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.point_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: point_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.point_requests (
    id bigint DEFAULT nextval('public.point_requests_id_seq'::regclass) NOT NULL,
    point integer,
    evaluation_id bigint NOT NULL,
    user_id bigint
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
-- Name: post_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post_types (
    id bigint DEFAULT nextval('public.poszttipus_seq'::regclass) NOT NULL,
    group_id bigint,
    name character varying(30) NOT NULL,
    delegated_post boolean DEFAULT false
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


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id bigint DEFAULT nextval('public.poszt_seq'::regclass) NOT NULL,
    membership_id bigint,
    post_type_id bigint
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
-- Name: privacies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.privacies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: privacies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.privacies (
    id bigint DEFAULT nextval('public.privacies_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    attribute_name character varying(64) NOT NULL,
    visible boolean DEFAULT false NOT NULL
);


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
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    target_type character varying NOT NULL,
    target_id integer NOT NULL,
    key character varying NOT NULL,
    subscribing boolean DEFAULT true NOT NULL,
    subscribing_to_email boolean DEFAULT true NOT NULL,
    subscribed_at timestamp without time zone,
    unsubscribed_at timestamp without time zone,
    subscribed_to_email_at timestamp without time zone,
    unsubscribed_to_email_at timestamp without time zone,
    optional_targets text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: svie_post_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.svie_post_requests (
    id integer NOT NULL,
    member_type character varying,
    user_id integer
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


--
-- Name: system_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_attributes (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);


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


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint DEFAULT nextval('public.users_usr_id_seq'::regclass) NOT NULL,
    email character varying(64),
    neptun character varying,
    firstname text NOT NULL,
    lastname text NOT NULL,
    nickname text,
    svie_member_type character varying(255) DEFAULT 'NEMTAG'::character varying NOT NULL,
    svie_primary_membership bigint,
    delegated boolean DEFAULT false NOT NULL,
    show_recommended_photo boolean DEFAULT false NOT NULL,
    screen_name character varying(50) NOT NULL,
    date_of_birth date,
    gender character varying(50) DEFAULT 'NOTSPECIFIED'::character varying NOT NULL,
    student_status character varying(50) DEFAULT 'UNKNOWN'::character varying NOT NULL,
    mother_name character varying(100),
    photo_path character varying(255),
    webpage character varying(255),
    cell_phone character varying(50),
    home_address character varying(255),
    est_grad character varying(10),
    dormitory character varying(50),
    room character varying(255),
    status character varying(8) DEFAULT 'INACTIVE'::character varying NOT NULL,
    password character varying(28),
    salt character varying(12),
    last_login timestamp without time zone,
    auth_sch_id character varying,
    bme_id character varying,
    created_at timestamp without time zone,
    metascore integer,
    place_of_birth character varying,
    birth_name character varying,
    updated_at timestamp without time zone
);


--
-- Name: view_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.view_settings (
    id integer NOT NULL,
    user_id integer,
    items_per_page integer,
    show_pictures boolean DEFAULT true,
    listing integer DEFAULT 1
);


--
-- Name: view_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.view_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: view_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.view_settings_id_seq OWNED BY public.view_settings.id;


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: point_detail_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_detail_comments ALTER COLUMN id SET DEFAULT nextval('public.point_detail_comments_id_seq'::regclass);


--
-- Name: point_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_details ALTER COLUMN id SET DEFAULT nextval('public.point_details_id_seq'::regclass);


--
-- Name: principles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principles ALTER COLUMN id SET DEFAULT nextval('public.principles_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: svie_post_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.svie_post_requests ALTER COLUMN id SET DEFAULT nextval('public.svie_post_requests_id_seq'::regclass);


--
-- Name: view_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.view_settings ALTER COLUMN id SET DEFAULT nextval('public.view_settings_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: entry_requests entry_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entry_requests
    ADD CONSTRAINT entry_requests_pkey PRIMARY KEY (id);


--
-- Name: evaluation_messages evaluation_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluation_messages
    ADD CONSTRAINT evaluation_messages_pkey PRIMARY KEY (id);


--
-- Name: evaluations evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: memberships grp_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
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
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: point_detail_comments point_detail_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_detail_comments
    ADD CONSTRAINT point_detail_comments_pkey PRIMARY KEY (id);


--
-- Name: point_details point_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_details
    ADD CONSTRAINT point_details_pkey PRIMARY KEY (id);


--
-- Name: point_histories point_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_histories
    ADD CONSTRAINT point_history_pkey PRIMARY KEY (id);


--
-- Name: point_requests point_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_requests
    ADD CONSTRAINT point_requests_pkey PRIMARY KEY (id);


--
-- Name: posts poszt_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT poszt_pkey PRIMARY KEY (id);


--
-- Name: post_types poszttipus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_types
    ADD CONSTRAINT poszttipus_pkey PRIMARY KEY (id);


--
-- Name: principles principles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principles
    ADD CONSTRAINT principles_pkey PRIMARY KEY (id);


--
-- Name: privacies privacies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privacies
    ADD CONSTRAINT privacies_pkey PRIMARY KEY (id);


--
-- Name: spot_images spot_images_usr_neptun_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spot_images
    ADD CONSTRAINT spot_images_usr_neptun_key UNIQUE (usr_neptun);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: svie_post_requests svie_post_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.svie_post_requests
    ADD CONSTRAINT svie_post_requests_pkey PRIMARY KEY (id);


--
-- Name: system_attributes system_attrs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_attributes
    ADD CONSTRAINT system_attrs_pkey PRIMARY KEY (id);


--
-- Name: memberships unique_memberships; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT unique_memberships UNIQUE (group_id, user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_usr_auth_sch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_usr_auth_sch_id_key UNIQUE (auth_sch_id);


--
-- Name: users users_usr_bme_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_usr_bme_id_key UNIQUE (bme_id);


--
-- Name: users users_usr_neptun_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_usr_neptun_key UNIQUE (neptun);


--
-- Name: users users_usr_screen_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_usr_screen_name_key UNIQUE (screen_name);


--
-- Name: view_settings view_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.view_settings
    ADD CONSTRAINT view_settings_pkey PRIMARY KEY (id);


--
-- Name: bel_tipus_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bel_tipus_idx ON public.entry_requests USING btree (entry_type);


--
-- Name: ert_semester_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ert_semester_idx ON public.evaluations USING btree (semester);


--
-- Name: fki_felado_usr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_felado_usr_id ON public.evaluation_messages USING btree (sender_user_id);


--
-- Name: fki_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_group_id ON public.evaluation_messages USING btree (group_id);


--
-- Name: groups_grp_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX groups_grp_id_idx ON public.groups USING btree (id);


--
-- Name: idx_groups_grp_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_groups_grp_name ON public.groups USING btree (name);


--
-- Name: idx_groups_grp_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_groups_grp_type ON public.groups USING btree (grp_type);


--
-- Name: index_notifications_on_group_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_group_owner_id ON public.notifications USING btree (group_owner_id);


--
-- Name: index_notifications_on_group_type_and_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_group_type_and_group_id ON public.notifications USING btree (group_type, group_id);


--
-- Name: index_notifications_on_notifiable_type_and_notifiable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_notifiable_type_and_notifiable_id ON public.notifications USING btree (notifiable_type, notifiable_id);


--
-- Name: index_notifications_on_notifier_type_and_notifier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_notifier_type_and_notifier_id ON public.notifications USING btree (notifier_type, notifier_id);


--
-- Name: index_notifications_on_target_type_and_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_target_type_and_target_id ON public.notifications USING btree (target_type, target_id);


--
-- Name: index_point_detail_comments_on_point_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_point_detail_comments_on_point_detail_id ON public.point_detail_comments USING btree (point_detail_id);


--
-- Name: index_point_detail_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_point_detail_comments_on_user_id ON public.point_detail_comments USING btree (user_id);


--
-- Name: index_subscriptions_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_key ON public.subscriptions USING btree (key);


--
-- Name: index_subscriptions_on_target_type_and_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_target_type_and_target_id ON public.subscriptions USING btree (target_type, target_id);


--
-- Name: index_subscriptions_on_target_type_and_target_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_on_target_type_and_target_id_and_key ON public.subscriptions USING btree (target_type, target_id, key);


--
-- Name: membership_usr_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX membership_usr_fk_idx ON public.memberships USING btree (user_id);


--
-- Name: next_version_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX next_version_idx ON public.evaluations USING btree (next_version NULLS FIRST);


--
-- Name: poszt_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX poszt_fk_idx ON public.posts USING btree (membership_id);


--
-- Name: unique_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_idx ON public.evaluations USING btree (group_id, semester, next_version NULLS FIRST);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: users_usr_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_usr_id_idx ON public.users USING btree (id);


--
-- Name: users_usr_neptun_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_usr_neptun_idx ON public.users USING btree (upper((neptun)::text));


--
-- Name: users_usr_screen_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_usr_screen_name_idx ON public.users USING btree (upper((screen_name)::text));


--
-- Name: groups $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT "$1" FOREIGN KEY (parent_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: lostpw_tokens fk1e9df02e5854b081; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lostpw_tokens
    ADD CONSTRAINT fk1e9df02e5854b081 FOREIGN KEY (usr_id) REFERENCES public.users(id);


--
-- Name: entry_requests fk4e301ac36958e716; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entry_requests
    ADD CONSTRAINT fk4e301ac36958e716 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: evaluations fk807db18871c0d156; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT fk807db18871c0d156 FOREIGN KEY (creator_user_id) REFERENCES public.users(id);


--
-- Name: evaluations fk807db18879696582; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT fk807db18879696582 FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: evaluations fk807db188b31cf015; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT fk807db188b31cf015 FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id);


--
-- Name: entry_requests fk_ertekeles_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entry_requests
    ADD CONSTRAINT fk_ertekeles_id FOREIGN KEY (evaluation_id) REFERENCES public.evaluations(id) ON DELETE CASCADE;


--
-- Name: point_requests fk_ertekeles_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_requests
    ADD CONSTRAINT fk_ertekeles_id FOREIGN KEY (evaluation_id) REFERENCES public.evaluations(id) ON DELETE CASCADE;


--
-- Name: evaluation_messages fk_felado_usr_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluation_messages
    ADD CONSTRAINT fk_felado_usr_id FOREIGN KEY (sender_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: evaluation_messages fk_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluation_messages
    ADD CONSTRAINT fk_group_id FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: evaluations fk_next_version; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT fk_next_version FOREIGN KEY (next_version) REFERENCES public.evaluations(id) ON DELETE SET NULL;


--
-- Name: point_detail_comments fk_rails_14e0ee0629; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_detail_comments
    ADD CONSTRAINT fk_rails_14e0ee0629 FOREIGN KEY (point_detail_id) REFERENCES public.point_details(id);


--
-- Name: view_settings fk_rails_2450b9d422; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.view_settings
    ADD CONSTRAINT fk_rails_2450b9d422 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: point_details fk_rails_6ef8df1bae; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_details
    ADD CONSTRAINT fk_rails_6ef8df1bae FOREIGN KEY (point_request_id) REFERENCES public.point_requests(id);


--
-- Name: principles fk_rails_84e8865fd0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principles
    ADD CONSTRAINT fk_rails_84e8865fd0 FOREIGN KEY (evaluation_id) REFERENCES public.evaluations(id);


--
-- Name: point_details fk_rails_dcebb805db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_details
    ADD CONSTRAINT fk_rails_dcebb805db FOREIGN KEY (principle_id) REFERENCES public.principles(id);


--
-- Name: point_detail_comments fk_rails_fd72f0d605; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_detail_comments
    ADD CONSTRAINT fk_rails_fd72f0d605 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: point_requests fkaa1034cd6958e716; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_requests
    ADD CONSTRAINT fkaa1034cd6958e716 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: memberships grp_membership_grp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT grp_membership_grp_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: memberships grp_membership_usr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT grp_membership_usr_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: im_accounts im_accounts_usr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.im_accounts
    ADD CONSTRAINT im_accounts_usr_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: log log_group; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_group FOREIGN KEY (grp_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: log log_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_user FOREIGN KEY (usr_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: point_histories point_history_usr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_histories
    ADD CONSTRAINT point_history_usr_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: posts poszt_grp_member_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT poszt_grp_member_fk FOREIGN KEY (membership_id) REFERENCES public.memberships(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: posts poszt_pttip_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT poszt_pttip_fk FOREIGN KEY (post_type_id) REFERENCES public.post_types(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: post_types poszttipus_opc_csoport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_types
    ADD CONSTRAINT poszttipus_opc_csoport FOREIGN KEY (group_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users users_main_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_main_group_fkey FOREIGN KEY (svie_primary_membership) REFERENCES public.memberships(id);


--
-- Name: privacies usr_private_attrs_usr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privacies
    ADD CONSTRAINT usr_private_attrs_usr_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20161124163851'),
('20171130184224'),
('20180315103617'),
('20180317194014'),
('20180317200507'),
('20180403171730'),
('20180501175635'),
('20180505152100'),
('20180617081041'),
('20180705121831'),
('20180730191308'),
('20181112160701'),
('20181220204207'),
('20190106175754'),
('20190427151354'),
('20191025190035'),
('20200127202810'),
('20200204185955');


