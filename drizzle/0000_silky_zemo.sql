CREATE TABLE `assets` (
	`id` text PRIMARY KEY NOT NULL,
	`project` text NOT NULL,
	`owner` text NOT NULL,
	`name` text NOT NULL,
	`mime` text NOT NULL,
	`size` integer NOT NULL,
	`created` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_assets_project` ON `assets` (`project`);--> statement-breakpoint
CREATE TABLE `comments` (
	`id` text PRIMARY KEY NOT NULL,
	`project` text NOT NULL,
	`page` text NOT NULL,
	`author` text NOT NULL,
	`name` text NOT NULL,
	`body` text NOT NULL,
	`created` integer NOT NULL,
	`resolved` integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_comments_project` ON `comments` (`project`);--> statement-breakpoint
CREATE TABLE `links` (
	`token` text PRIMARY KEY NOT NULL,
	`project` text NOT NULL,
	`role` text NOT NULL,
	`created` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_links_project` ON `links` (`project`);--> statement-breakpoint
CREATE TABLE `members` (
	`project` text NOT NULL,
	`email` text NOT NULL,
	`role` text NOT NULL,
	PRIMARY KEY(`project`, `email`)
);
--> statement-breakpoint
CREATE INDEX `idx_members_email` ON `members` (`email`);--> statement-breakpoint
CREATE TABLE `operations` (
	`id` text PRIMARY KEY NOT NULL,
	`project` text NOT NULL,
	`actor` text NOT NULL,
	`revision` integer NOT NULL,
	`changes` text NOT NULL,
	`created` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_operations_project_revision` ON `operations` (`project`,`revision`);--> statement-breakpoint
CREATE TABLE `presence` (
	`project` text NOT NULL,
	`actor` text NOT NULL,
	`name` text NOT NULL,
	`page` text,
	`x` integer,
	`y` integer,
	`updated` integer NOT NULL,
	PRIMARY KEY(`project`, `actor`)
);
--> statement-breakpoint
CREATE INDEX `idx_presence_project_updated` ON `presence` (`project`,`updated`);--> statement-breakpoint
CREATE TABLE `projects` (
	`id` text PRIMARY KEY NOT NULL,
	`owner` text NOT NULL,
	`name` text NOT NULL,
	`data` text NOT NULL,
	`revision` integer DEFAULT 0 NOT NULL,
	`updated` integer NOT NULL,
	`last_op` text,
	`folder` text DEFAULT '' NOT NULL,
	`starred` integer DEFAULT 0 NOT NULL,
	`deleted` integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_projects_owner_updated` ON `projects` (`owner`,`updated`);--> statement-breakpoint
CREATE TABLE `snapshots` (
	`id` text PRIMARY KEY NOT NULL,
	`project` text NOT NULL,
	`name` text NOT NULL,
	`data` text NOT NULL,
	`created` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_snapshots_project` ON `snapshots` (`project`);