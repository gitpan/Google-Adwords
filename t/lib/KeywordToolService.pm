package KeywordToolService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

use Google::Adwords::SiteKeyword;

use Data::Dumper;

sub test_class { return "Google::Adwords::KeywordToolService"; }

# tests to run
my %tests = (
    getKeywordsFromSite    => 1,
    getKeywordVariations   => 1,
    getKeywordVariations_2 => 1,
);

sub start_of_each_test : Test(setup)
{
    my $self = shift;

    # set debug to whatever was passed in as param
    $self->{obj}->debug( $self->{debug} );
}

sub getKeywordsFromSite : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} )
    {
        return;
    }

    if ( $self->{sandbox} )
    {

        my $url                  = 'http://rohan.almeida.in';
        my $include_linked_pages = 0;
        my $languages_ref        = [ 'en', ];
        my $countries_ref        = [ 'IN', ];

        my $site_keyword_groups = $self->{obj}->getKeywordsFromSite(
            {
                url                => $url,
                includeLinkedPages => $include_linked_pages,
                languages          => $languages_ref,
                countries          => $countries_ref,
            }
        );

        my $groups_ref = $site_keyword_groups->groups;
        ok( scalar @{$groups_ref} > 0, 'getKeywordsFromSite (groups)' );
        my $keywords_ref = $site_keyword_groups->keywords;
        ok( ref $keywords_ref->[0] eq 'Google::Adwords::SiteKeyword',
            'getKeywordsFromSite (keywords)' );
    } # end if ( $self->{sandbox} ...
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
<getKeywordsFromSiteResponse xmlns="">
   <ns1:getKeywordsFromSiteReturn xmlns:ns1="https://adwords.google.com/api/adwords/v8">
    <ns1:groups>DDDDD</ns1:groups>
    <ns1:groups>EEEEE</ns1:groups>
    <ns1:groups>FFFFF</ns1:groups>
    <ns1:groups>GGGGG</ns1:groups>
    <ns1:groups>HHHHH</ns1:groups>
    <ns1:groups>IIIII</ns1:groups>
    <ns1:groups>JJJJJ</ns1:groups>
    <ns1:groups>KKKKK</ns1:groups>
    <ns1:groups>LLLLL</ns1:groups>
    <ns1:groups>MMMMM</ns1:groups>
    <ns1:keywords>
     <ns1:text>add google search</ns1:text>
     <ns1:groupId>0</ns1:groupId>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google norge</ns1:text>
     <ns1:groupId>1</ns1:groupId>
     <ns1:advertiserCompetitionScale>0</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google tools</ns1:text>
     <ns1:groupId>2</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google listing</ns1:text>
     <ns1:groupId>3</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>adwords google login</ns1:text>
     <ns1:groupId>4</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>text messaging sms</ns1:text>
     <ns1:groupId>5</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>4</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>business solutions</ns1:text>
     <ns1:groupId>6</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>more more more</ns1:text>
     <ns1:groupId>7</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>add google search to your site</ns1:text>
     <ns1:groupId>8</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google search on your site</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>0</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>options</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google listing</ns1:text>
     <ns1:groupId>3</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>1</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>earth google</ns1:text>
     <ns1:groupId>1</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google business</ns1:text>
     <ns1:groupId>0</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>blog search</ns1:text>
     <ns1:groupId>6</ns1:groupId>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>4</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google options</ns1:text>
     <ns1:groupId>5</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google websearch</ns1:text>
     <ns1:groupId>6</ns1:groupId>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>more and more</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>0</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>verizon text messaging</ns1:text>
     <ns1:groupId>7</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>internet text messaging</ns1:text>
     <ns1:groupId>7</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>php mailing lists</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>more and more</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>text messaging sms</ns1:text>
     <ns1:groupId>5</ns1:groupId>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>4</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>add google search to your site</ns1:text>
     <ns1:groupId>8</ns1:groupId>
     <ns1:advertiserCompetitionScale>0</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google search on your website</ns1:text>
     <ns1:groupId>5</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>tools</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>1</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google text messaging</ns1:text>
     <ns1:groupId>4</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>4</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google images com</ns1:text>
     <ns1:groupId>4</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>1</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>more google</ns1:text>
     <ns1:groupId>5</ns1:groupId>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>blog</ns1:text>
     <ns1:groupId>6</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>online text messaging</ns1:text>
     <ns1:groupId>5</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>tools</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>www google com</ns1:text>
     <ns1:groupId>7</ns1:groupId>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google search on your site</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>4</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google stuff</ns1:text>
     <ns1:groupId>8</ns1:groupId>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>more and more</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google tools</ns1:text>
     <ns1:groupId>2</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google norge</ns1:text>
     <ns1:groupId>1</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google products</ns1:text>
     <ns1:groupId>3</ns1:groupId>
     <ns1:advertiserCompetitionScale>0</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>free text messaging</ns1:text>
     <ns1:groupId>7</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google map</ns1:text>
     <ns1:groupId>0</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google sponsored links</ns1:text>
     <ns1:groupId>8</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google norge</ns1:text>
     <ns1:groupId>1</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>text messaging software</ns1:text>
     <ns1:groupId>7</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google norge</ns1:text>
     <ns1:groupId>1</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>ww google</ns1:text>
     <ns1:groupId>4</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>free text messaging</ns1:text>
     <ns1:groupId>7</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google service</ns1:text>
     <ns1:groupId>6</ns1:groupId>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google business</ns1:text>
     <ns1:groupId>0</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>add google</ns1:text>
     <ns1:groupId>0</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>4</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google norge</ns1:text>
     <ns1:groupId>1</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google blog</ns1:text>
     <ns1:groupId>5</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google publisher</ns1:text>
     <ns1:groupId>8</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>1</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google profits</ns1:text>
     <ns1:groupId>2</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>1</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google adds</ns1:text>
     <ns1:groupId>6</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google money</ns1:text>
     <ns1:groupId>2</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>4</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>adwords google login</ns1:text>
     <ns1:groupId>4</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>0</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>more &amp;amp; more</ns1:text>
     <ns1:groupId>8</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>adwords google login</ns1:text>
     <ns1:groupId>4</ns1:groupId>
     <ns1:advertiserCompetitionScale>0</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google sitemaps</ns1:text>
     <ns1:groupId>9</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google clothes</ns1:text>
     <ns1:groupId>3</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google norge</ns1:text>
     <ns1:groupId>1</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>www google com</ns1:text>
     <ns1:groupId>7</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>www google com</ns1:text>
     <ns1:groupId>7</ns1:groupId>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>3</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google options</ns1:text>
     <ns1:groupId>5</ns1:groupId>
     <ns1:advertiserCompetitionScale>3</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google blog</ns1:text>
     <ns1:groupId>5</ns1:groupId>
     <ns1:advertiserCompetitionScale>0</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>1</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google usa</ns1:text>
     <ns1:groupId>1</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>1</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>mail google</ns1:text>
     <ns1:groupId>3</ns1:groupId>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google appliance</ns1:text>
     <ns1:groupId>0</ns1:groupId>
     <ns1:advertiserCompetitionScale>2</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>1</ns1:searchVolumeScale>
    </ns1:keywords>
    <ns1:keywords>
     <ns1:text>google business</ns1:text>
     <ns1:groupId>0</ns1:groupId>
     <ns1:advertiserCompetitionScale>4</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>2</ns1:searchVolumeScale>
    </ns1:keywords>
   </ns1:getKeywordsFromSiteReturn>
  </getKeywordsFromSiteResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $url                  = 'http://aarohan.biz';
        my $include_linked_pages = 0;
        my $languages_ref        = [ 'en', ];
        my $countries_ref        = [ 'IN', ];

        my $site_keyword_groups = $self->{obj}->getKeywordsFromSite(
            {
                url                => $url,
                includeLinkedPages => $include_linked_pages,
                languages          => $languages_ref,
                countries          => $countries_ref,
            }
        );

        my $groups_ref = $site_keyword_groups->groups;
        ok( scalar @{$groups_ref} > 0, 'getKeywordsFromSite (groups)' );
        my $keywords_ref = $site_keyword_groups->keywords;
        ok( ref $keywords_ref->[0] eq 'Google::Adwords::SiteKeyword',
            'getKeywordsFromSite (keywords)' );

    }

} # end sub getKeywordsFromSite :

sub getKeywordVariations : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} )
    {
        return;
    }

    if ( $self->{sandbox} )
    {

        my $seed_keyword1 = Google::Adwords::SeedKeyword->new;
        $seed_keyword1->negative(0);
        $seed_keyword1->text('Linux Perl');
        $seed_keyword1->type('Broad');

        my $keyword_variations = $self->{obj}->getKeywordVariations(
            {
                seedKeywords => [ $seed_keyword1, ],
                useSynonyms  => 1,
                languages    => [ 'en', ],
                countries    => [ 'US', ],
            }
        );

        ok( scalar @{ $keyword_variations->moreSpecific } > 0,
            'getKeywordVariations' );

    } # end if ( $self->{sandbox} ...
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
<getKeywordVariationsResponse xmlns="">
   <ns1:getKeywordVariationsReturn xmlns:ns1="https://adwords.google.com/api/adwords/v8">
    <ns1:moreSpecific>
     <ns1:text>suggestion Perl Linux</ns1:text>
     <ns1:language>en</ns1:language>
     <ns1:advertiserCompetitionScale>5</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>1</ns1:searchVolumeScale>
    </ns1:moreSpecific>
    <ns1:moreSpecific>
     <ns1:text>suggestion Linux Perl</ns1:text>
     <ns1:language>en</ns1:language>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:moreSpecific>
   </ns1:getKeywordVariationsReturn>
  </getKeywordVariationsResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $seed_keyword1 = Google::Adwords::SeedKeyword->new;
        $seed_keyword1->negative(0);
        $seed_keyword1->text('Linux Perl');
        $seed_keyword1->type('Broad');

        my $keyword_variations = $self->{obj}->getKeywordVariations(
            {
                seedKeywords => [ $seed_keyword1, ],
                useSynonyms  => 1,
                languages    => [ 'en', ],
                countries    => [ 'US', ],
            }
        );

        my $more_specific_ref = $keyword_variations->moreSpecific;
        ok( $more_specific_ref->[0]->text eq 'suggestion Perl Linux',
            'getKeywordVariations' );

    }

} # end sub getKeywordVariations :

sub getKeywordVariations_2 : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} )
    {
        return;
    }

    if ( $self->{sandbox} )
    {

    }
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
<getKeywordVariationsResponse xmlns="">
   <ns1:getKeywordVariationsReturn xmlns:ns1="https://adwords.google.com/api/adwords/v8">
    <ns1:moreSpecific>
     <ns1:text>suggestion Linux Perl</ns1:text>
     <ns1:language>en</ns1:language>
     <ns1:advertiserCompetitionScale>1</ns1:advertiserCompetitionScale>
     <ns1:searchVolumeScale>5</ns1:searchVolumeScale>
    </ns1:moreSpecific>
   </ns1:getKeywordVariationsReturn>
  </getKeywordVariationsResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $seed_keyword1 = Google::Adwords::SeedKeyword->new;
        $seed_keyword1->negative(0);
        $seed_keyword1->text('Linux Perl');
        $seed_keyword1->type('Broad');

        my $keyword_variations = $self->{obj}->getKeywordVariations(
            {
                seedKeywords => [ $seed_keyword1, ],
                useSynonyms  => 1,
                languages    => [ 'en', ],
                countries    => [ 'US', ],
            }
        );

        my $more_specific_ref = $keyword_variations->moreSpecific;
        ok( $more_specific_ref->[0]->text eq 'suggestion Linux Perl',
            'getKeywordVariations' );

    }

} # end sub getKeywordVariations_2 :

1;

