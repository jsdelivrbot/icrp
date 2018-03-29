--
-- Update About Us Node
--

UPDATE `node__body` SET bundle = 'page', deleted = 0, revision_id = 6, langcode = 'en', delta = 0, body_value = '&zwj;', body_summary = '', body_format = 'full_html' WHERE entity_id = 6;
UPDATE `node_revision__body` SET bundle = 'page', deleted = 0, revision_id = 6, langcode = 'en', delta = 0, body_value = '&zwj;', body_summary = '', body_format = 'full_html' WHERE entity_id = 6;

--
-- Create About Us Block
--

INSERT INTO `block_content` (id, revision_id, type, uuid, langcode) VALUES (29,29,'basic','5b457aa4-9d15-48e0-8a27-4d8d0b9acbce','en');
INSERT INTO `block_content__body` (`bundle`,`deleted`,`entity_id`,`revision_id`,`langcode`,`delta`,`body_value`,`body_summary`,`body_format`) VALUES ('basic',0,29,29,'en',0,'<div id=\"about-us-container\">\r\n<h1>About the Partners</h1>\r\n\r\n<p>The International Cancer Research Partnership (ICRP) is a unique alliance of cancer research organizations from Australia, Canada, France, Japan, the Netherlands, United Kingdom, and the United States.&nbsp; The Partners share funding information to enhance global collaboration and strategic coordination of research between individual&nbsp; researchers and organizations.</p>\r\n\r\n<h2>Learn More About ...</h2>\r\n\r\n<div class=\"panel panel-default\" id=\"about-us-1\">\r\n<div class=\"panel-heading\"><a aria-controls=\"about-us-1--content\" aria-expanded=\"true\" aria-pressed=\"true\" class=\"panel-title\" data-toggle=\"collapse\" href=\"#about-us-1--content\" role=\"button\">Our Partners</a></div>\r\n\r\n<div class=\"panel-body panel-collapse collapse fade in\" id=\"about-us-1--content\"><!-- Body 1 -->\r\n<div class=\"about-us-body\">\r\n<p><a href=\"/partners\">ICRP partners</a> represent a wide range of governmental, public and non-profit cancer research funding organizations from across the world.</p>\r\n</div>\r\n</div>\r\n</div>\r\n\r\n<div class=\"panel panel-default\" id=\"about-us-2\">\r\n<div class=\"panel-heading\"><a aria-controls=\"about-us-2--content\" aria-expanded=\"true\" aria-pressed=\"true\" class=\"panel-title\" data-toggle=\"collapse\" href=\"#about-us-2--content\" role=\"button\">Our Leadership</a></div>\r\n\r\n<div class=\"panel-body panel-collapse collapse fade in\" id=\"about-us-2--content\"><!-- Body 2 -->\r\n<div class=\"about-us-body\">\r\n<dl>\r\n	<dt>Chair</dt>\r\n	<dd>Katherine McKenzie, PhD (California Breast Cancer Research Program, US)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Vice-Chair</dt>\r\n	<dd>Naba Bora, PhD (Congressionally Directed Medical Research Programs (CDMRP), U.S. Dept. of Defense)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Website &amp; Database Committee</dt>\r\n	<dd>Chair: Michelle Bennett, PhD (NCI Center for Research Strategy, USA)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Finance Committee</dt>\r\n	<dd>Chair: Kimberly Badovinac, MA, MBA (Canadian Cancer Research Alliance)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Annual Meeting 2017 Committee</dt>\r\n	<dd>Chair: Stuart Griffiths, PhD (National Cancer Research Institute, UK)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Operations Committee</dt>\r\n	<dd>Co-Chair: Marion Kavanaugh-Lynch, PhD (California Breast Cancer Research Program, USA)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Communications and Membership Committee</dt>\r\n	<dd>Chair: Lisa Stevens, PhD (NCI Center for Global Health, USA)</dd>\r\n	<dd>Vice-Chair: Paul Jackson, PhD (Cancer Australia)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Data Quality and Analysis Committee</dt>\r\n	<dd>Chair: Kimberly Badovinac, MA, MBA (Canadian Cancer Research Alliance)</dd>\r\n	<dd>Vice-Chair: Karima Bourougaa, PhD (Institut National du Cancer, France)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Evaluations Committee</dt>\r\n	<dd>Chair: Kari Wojtanik, PhD (Susan G. Komen for the Cure)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Operations Manager</dt>\r\n	<dd>Lynne Davies, PhD</dd>\r\n</dl>\r\n</div>\r\n</div>\r\n</div>\r\n\r\n<div class=\"panel panel-default\" id=\"about-us-3\">\r\n<div class=\"panel-heading\"><a aria-controls=\"about-us-3--content\" aria-expanded=\"false\" aria-pressed=\"true\" class=\"panel-title collapsed\" data-toggle=\"collapse\" href=\"#about-us-3--content\" role=\"button\">Our Partner Representatives</a></div>\r\n\r\n<div aria-expanded=\"false\" class=\"panel-body panel-collapse fade collapse\" id=\"about-us-3--content\" style=\"height: 30px;\"><!-- Body 3 -->\r\n<div class=\"about-us-body\">\r\n<p>Each partner organization designates one or more person as an official contact for the ICRP and these individuals are listed below. Multiple staff members from organizations are welcome to participate in ICRP events, activities and projects.</p>\r\n\r\n<div>\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">USA</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>American Institute for Cancer Research (AICR)</td>\r\n			<td>Nigel Brockton, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>American Cancer Society (ACS)</td>\r\n			<td>Cheri Richard, MS<br />\r\n			T.J. Koerner, PhD<br />\r\n			Erin Stratton, MPH</td>\r\n		</tr>\r\n		<tr>\r\n			<td>American Society for Radiation Oncology (ASTRO)</td>\r\n			<td>Judy Keen, PhD<br />\r\n			Tyler Beck, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Avon Breast Cancer Crusade (Avon)</td>\r\n			<td>Carolyn Ricci</td>\r\n		</tr>\r\n		<tr>\r\n			<td>California Breast Cancer Research Program (CBCRP)</td>\r\n			<td>Mhel Kavanaugh-Lynch, MD, MPH<br />\r\n			Katie McKenzie, PhD<br />\r\n			Senaida Poole, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Coalition Against Childhood Cancer (CAC2) – representing over 10 funding organizations</td>\r\n			<td>Lisa Towry</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Congressionally Directed Medical Research Programs (CDMRP), U.S. Dept. of Defense</td>\r\n			<td>Naba Bora, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>National Cancer Institute (NCI) - Center for Research Strategy</td>\r\n			<td>Michelle Bennett, PhD<br />\r\n			Eddie Billingslea, PhD<br />\r\n			Melissa Antman, PhD<br />\r\n			Laura Brockway Lunardi, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>National Cancer Institute (NCI) / DEA/RAEB</td>\r\n			<td>Marilyn Gaston<br />\r\n			Ed Kyle<br />\r\n			Beth Buschling</td>\r\n		</tr>\r\n		<tr>\r\n			<td>National Cancer Institute (NCI) - Center for Global Health</td>\r\n			<td>Lisa Stevens, PhD<br />\r\n			Rachel Abudu, MPH (Leidos Biomedical Research Inc.)<br />\r\n			Douglas Puricelli Perin, MPH, JD (Leidos Biomedical Research, Inc.)<br />\r\n			Kalina Duncan, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Oncology Nursing Society Foundation (ONS)</td>\r\n			<td>Linda Worrall, RN, MSN</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Pancreatic Cancer Action Network (Pancan)</td>\r\n			<td>Donna Manross, BS<br />\r\n			Maya Bader, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Susan G. Komen® (Komen)</td>\r\n			<td>Stephanie Birkey-Reffey, PhD<br />\r\n			Kari Wojtanik, PhD<br />\r\n			Jerome Jourquin, PhD<br />\r\n			Annabel Oh, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">Canada</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>Canadian Cancer Research Alliance (CCRA) Representing 42 Canadian cancer organizations</td>\r\n			<td>Kim Badovinac, MA, MBA</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">Netherlands</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>Dutch Cancer Society / Kankerbestrijding (KWF)</td>\r\n			<td>Annemarie Weerman, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">France</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>French National Cancer Institute / Institut National du Cancer (INCa)</td>\r\n			<td>Karima Bourougaa, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">UK</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>National Cancer Research Institute (NCRI) Representing over 20 UK funders</td>\r\n			<td>Stuart Griffiths, PhD<br />\r\n			Sam Gibbons Frendo</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">Japan</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>National Cancer Center (NCC) Japan</td>\r\n			<td>Toshio Ogawa, MSc, PhD<br />\r\n			Teruhiko Yoshida</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">Australia</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>Cancer Institute New South Wales (CINSW)</td>\r\n			<td>Veronica McCabe, PhD<br />\r\n			Emma Heeley, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Cancer Australia (CancerAust)</td>\r\n			<td>Paul Jackson, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>National Breast Cancer Foundation (NBCF)</td>\r\n			<td>Chris Pettigrew, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">International</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>World Cancer Research Fund International</td>\r\n			<td>Giota Mitrou, PhD<br />\r\n			Anna Diaz Font, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n','','full_html');
INSERT INTO `block_content_field_data` (id, revision_id, type, langcode, info, changed, `revision_translation_affected`, `default_langcode`, `status`) VALUES (29,29,'basic','en','About Us',1518106929,1,1, 1);
INSERT INTO `block_content_field_revision` (id, revision_id, langcode, info, changed, `revision_translation_affected`, `default_langcode`, `status`) VALUES (29,29,'en','About Us',1518106929,1,1,1);
INSERT INTO `block_content_revision` (id, revision_id, langcode, `revision_created`, `revision_user`, `revision_default`) VALUES (29,29,'en',1518106929,1, 1);
INSERT INTO `block_content_revision__body` (`bundle`,`deleted`,`entity_id`,`revision_id`,`langcode`,`delta`,`body_value`,`body_summary`,`body_format`) VALUES ('basic',0,29,29,'en',0,'<div id=\"about-us-container\">\r\n<h1>About the Partners</h1>\r\n\r\n<p>The International Cancer Research Partnership (ICRP) is a unique alliance of cancer research organizations from Australia, Canada, France, Japan, the Netherlands, United Kingdom, and the United States.&nbsp; The Partners share funding information to enhance global collaboration and strategic coordination of research between individual&nbsp; researchers and organizations.</p>\r\n\r\n<h2>Learn More About ...</h2>\r\n\r\n<div class=\"panel panel-default\" id=\"about-us-1\">\r\n<div class=\"panel-heading\"><a aria-controls=\"about-us-1--content\" aria-expanded=\"true\" aria-pressed=\"true\" class=\"panel-title\" data-toggle=\"collapse\" href=\"#about-us-1--content\" role=\"button\">Our Partners</a></div>\r\n\r\n<div class=\"panel-body panel-collapse collapse fade in\" id=\"about-us-1--content\"><!-- Body 1 -->\r\n<div class=\"about-us-body\">\r\n<p><a href=\"/partners\">ICRP partners</a> represent a wide range of governmental, public and non-profit cancer research funding organizations from across the world.</p>\r\n</div>\r\n</div>\r\n</div>\r\n\r\n<div class=\"panel panel-default\" id=\"about-us-2\">\r\n<div class=\"panel-heading\"><a aria-controls=\"about-us-2--content\" aria-expanded=\"true\" aria-pressed=\"true\" class=\"panel-title\" data-toggle=\"collapse\" href=\"#about-us-2--content\" role=\"button\">Our Leadership</a></div>\r\n\r\n<div class=\"panel-body panel-collapse collapse fade in\" id=\"about-us-2--content\"><!-- Body 2 -->\r\n<div class=\"about-us-body\">\r\n<dl>\r\n	<dt>Chair</dt>\r\n	<dd>Katherine McKenzie, PhD (California Breast Cancer Research Program, US)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Vice-Chair</dt>\r\n	<dd>Naba Bora, PhD (Congressionally Directed Medical Research Programs (CDMRP), U.S. Dept. of Defense)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Website &amp; Database Committee</dt>\r\n	<dd>Chair: Michelle Bennett, PhD (NCI Center for Research Strategy, USA)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Finance Committee</dt>\r\n	<dd>Chair: Kimberly Badovinac, MA, MBA (Canadian Cancer Research Alliance)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Annual Meeting 2017 Committee</dt>\r\n	<dd>Chair: Stuart Griffiths, PhD (National Cancer Research Institute, UK)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Operations Committee</dt>\r\n	<dd>Co-Chair: Marion Kavanaugh-Lynch, PhD (California Breast Cancer Research Program, USA)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Communications and Membership Committee</dt>\r\n	<dd>Chair: Lisa Stevens, PhD (NCI Center for Global Health, USA)</dd>\r\n	<dd>Vice-Chair: Paul Jackson, PhD (Cancer Australia)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Data Quality and Analysis Committee</dt>\r\n	<dd>Chair: Kimberly Badovinac, MA, MBA (Canadian Cancer Research Alliance)</dd>\r\n	<dd>Vice-Chair: Karima Bourougaa, PhD (Institut National du Cancer, France)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Evaluations Committee</dt>\r\n	<dd>Chair: Kari Wojtanik, PhD (Susan G. Komen for the Cure)</dd>\r\n</dl>\r\n\r\n<dl>\r\n	<dt>Operations Manager</dt>\r\n	<dd>Lynne Davies, PhD</dd>\r\n</dl>\r\n</div>\r\n</div>\r\n</div>\r\n\r\n<div class=\"panel panel-default\" id=\"about-us-3\">\r\n<div class=\"panel-heading\"><a aria-controls=\"about-us-3--content\" aria-expanded=\"false\" aria-pressed=\"true\" class=\"panel-title collapsed\" data-toggle=\"collapse\" href=\"#about-us-3--content\" role=\"button\">Our Partner Representatives</a></div>\r\n\r\n<div aria-expanded=\"false\" class=\"panel-body panel-collapse fade collapse\" id=\"about-us-3--content\" style=\"height: 30px;\"><!-- Body 3 -->\r\n<div class=\"about-us-body\">\r\n<p>Each partner organization designates one or more person as an official contact for the ICRP and these individuals are listed below. Multiple staff members from organizations are welcome to participate in ICRP events, activities and projects.</p>\r\n\r\n<div>\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">USA</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>American Institute for Cancer Research (AICR)</td>\r\n			<td>Nigel Brockton, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>American Cancer Society (ACS)</td>\r\n			<td>Cheri Richard, MS<br />\r\n			T.J. Koerner, PhD<br />\r\n			Erin Stratton, MPH</td>\r\n		</tr>\r\n		<tr>\r\n			<td>American Society for Radiation Oncology (ASTRO)</td>\r\n			<td>Judy Keen, PhD<br />\r\n			Tyler Beck, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Avon Breast Cancer Crusade (Avon)</td>\r\n			<td>Carolyn Ricci</td>\r\n		</tr>\r\n		<tr>\r\n			<td>California Breast Cancer Research Program (CBCRP)</td>\r\n			<td>Mhel Kavanaugh-Lynch, MD, MPH<br />\r\n			Katie McKenzie, PhD<br />\r\n			Senaida Poole, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Coalition Against Childhood Cancer (CAC2) – representing over 10 funding organizations</td>\r\n			<td>Lisa Towry</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Congressionally Directed Medical Research Programs (CDMRP), U.S. Dept. of Defense</td>\r\n			<td>Naba Bora, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>National Cancer Institute (NCI) - Center for Research Strategy</td>\r\n			<td>Michelle Bennett, PhD<br />\r\n			Eddie Billingslea, PhD<br />\r\n			Melissa Antman, PhD<br />\r\n			Laura Brockway Lunardi, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>National Cancer Institute (NCI) / DEA/RAEB</td>\r\n			<td>Marilyn Gaston<br />\r\n			Ed Kyle<br />\r\n			Beth Buschling</td>\r\n		</tr>\r\n		<tr>\r\n			<td>National Cancer Institute (NCI) - Center for Global Health</td>\r\n			<td>Lisa Stevens, PhD<br />\r\n			Rachel Abudu, MPH (Leidos Biomedical Research Inc.)<br />\r\n			Douglas Puricelli Perin, MPH, JD (Leidos Biomedical Research, Inc.)<br />\r\n			Kalina Duncan, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Oncology Nursing Society Foundation (ONS)</td>\r\n			<td>Linda Worrall, RN, MSN</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Pancreatic Cancer Action Network (Pancan)</td>\r\n			<td>Donna Manross, BS<br />\r\n			Maya Bader, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Susan G. Komen® (Komen)</td>\r\n			<td>Stephanie Birkey-Reffey, PhD<br />\r\n			Kari Wojtanik, PhD<br />\r\n			Jerome Jourquin, PhD<br />\r\n			Annabel Oh, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">Canada</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>Canadian Cancer Research Alliance (CCRA) Representing 42 Canadian cancer organizations</td>\r\n			<td>Kim Badovinac, MA, MBA</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">Netherlands</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>Dutch Cancer Society / Kankerbestrijding (KWF)</td>\r\n			<td>Annemarie Weerman, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">France</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>French National Cancer Institute / Institut National du Cancer (INCa)</td>\r\n			<td>Karima Bourougaa, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">UK</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>National Cancer Research Institute (NCRI) Representing over 20 UK funders</td>\r\n			<td>Stuart Griffiths, PhD<br />\r\n			Sam Gibbons Frendo</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">Japan</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>National Cancer Center (NCC) Japan</td>\r\n			<td>Toshio Ogawa, MSc, PhD<br />\r\n			Teruhiko Yoshida</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">Australia</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>Cancer Institute New South Wales (CINSW)</td>\r\n			<td>Veronica McCabe, PhD<br />\r\n			Emma Heeley, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>Cancer Australia (CancerAust)</td>\r\n			<td>Paul Jackson, PhD</td>\r\n		</tr>\r\n		<tr>\r\n			<td>National Breast Cancer Foundation (NBCF)</td>\r\n			<td>Chris Pettigrew, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<table class=\"table table-bordered\">\r\n	<thead>\r\n		<tr>\r\n			<th style=\"width: 50%\">International</th>\r\n			<th style=\"width: 50%\">Representatives</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>World Cancer Research Fund International</td>\r\n			<td>Giota Mitrou, PhD<br />\r\n			Anna Diaz Font, PhD</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n','','full_html');

--
-- Create Edit About Us Block
--

INSERT INTO `block_content` (id, revision_id, type, uuid, langcode) VALUES (30,30,'basic','67e38b55-8fb6-444a-a2c4-c15ea258d572','en');
INSERT INTO `block_content__body` (`bundle`,`deleted`,`entity_id`,`revision_id`,`langcode`,`delta`,`body_value`,`body_summary`,`body_format`) VALUES ('basic',0,30,30,'en',0,'<p class=\"text-right\"><a href=\"/block/29/?destination=about-us\">Edit</a></p>','','full_html');
INSERT INTO `block_content_field_data` (id, revision_id, type, langcode, info, changed, `revision_translation_affected`, `default_langcode`, `status`) VALUES (30,30,'basic','en','Edit About Us Button',1518108821,1,1,1);
INSERT INTO `block_content_field_revision` (id, revision_id, langcode, info, changed, `revision_translation_affected`, `default_langcode`, `status`) VALUES (30,30,'en','Edit About Us Button',1518108821,1,1,1);
INSERT INTO `block_content_revision`  (id, revision_id, langcode, `revision_created`, `revision_user`, `revision_default`) VALUES (30,30,'en',NULL,1518108821,NULL);
INSERT INTO `block_content_revision__body` (`bundle`,`deleted`,`entity_id`,`revision_id`,`langcode`,`delta`,`body_value`,`body_summary`,`body_format`) VALUES ('basic',0,30,30,'en',0,'<p class=\"text-right\"><a href=\"/block/29/?destination=about-us\">Edit</a></p>','','full_html');
