CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE user_type AS ENUM ('admin', 'regular');

CREATE TABLE "user" (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    email VARCHAR(120) UNIQUE NOT NULL,
    user_type user_type NOT NULL,
    jobs_completed INTEGER DEFAULT 0,
);

CREATE TABLE template (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    template_id VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    checklist JSONB NOT NULL,
    created_by UUID NOT NULL REFERENCES "user" (id)
);

CREATE TABLE job (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    title VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    checklist JSONB NOT NULL,
    completed_by INTEGER REFERENCES "user" (id),
    completed_at TIMESTAMP WITHOUT TIME ZONE,
    template_id UUID NOT NULL REFERENCES template (template_id)
);

CREATE INDEX idx_template_created_by ON template (created_by);

CREATE INDEX idx_job_completed_by ON job (completed_by);

CREATE INDEX idx_job_template_id ON job (template_id);
