#!/usr/bin/perl
use strict;
use warnings;

use lib 't/lib';
use Service;
use InfoService;
use Campaign;
use GeoTarget;
use CampaignService;
use AdGroupService;
use AccountService;
use AdService;
use ReportService;
use TrafficEstimatorService;
use CriterionService;
use KeywordToolService;

Test::Class->runtests();

