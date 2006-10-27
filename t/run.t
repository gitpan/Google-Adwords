#!/usr/bin/perl
use strict; use warnings;

use lib 't/lib';
use Service;
use InfoService;
use Campaign;
use CampaignService;
use AdGroupService;
use AccountService;
use CreativeService;
use ReportService;
use TrafficEstimatorService;

Test::Class->runtests();

