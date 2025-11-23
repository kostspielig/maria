defmodule MariaWeb.CvLive do
  use MariaWeb, :live_view_basic

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; line-height: 1.7; color: #1a1a1a; background: #fff; padding: 60px 40px; font-size: 16px; }
      .container { max-width: 850px; margin: 0 auto; }
      .header { margin-bottom: 60px; border-bottom: 1px solid #e0e0e0; padding-bottom: 30px; }
      .header h1 { font-size: 2.2em; margin-bottom: 8px; font-weight: 600; letter-spacing: -0.02em; }
      .header .subtitle { font-size: 1.1em; color: #666; margin-bottom: 20px; }
      .contact { display: flex; gap: 25px; flex-wrap: wrap; font-size: 0.95em; color: #666; }
      .contact a { color: #666; text-decoration: none; }
      .contact a:hover { color: #1a1a1a; }
      .section { margin-bottom: 55px; }
      .section-title { font-size: 0.85em; text-transform: uppercase; letter-spacing: 0.1em; color: #999; margin-bottom: 30px; font-weight: 600; }
      .experience-item { margin-bottom: 45px; }
      .company-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 25px; }
      .company-name { font-size: 1.2em; font-weight: 600; color: #1a1a1a; }
      .role { margin-bottom: 15px; padding-left: 0; }
      .role-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 12px; }
      .role-title { font-weight: 500; color: #1a1a1a; }
      .date { color: #999; font-size: 0.9em; }
      .description { color: #4a4a4a; margin-bottom: 10px; line-height: 1.7; }
      .achievements { list-style: none; color: #4a4a4a; line-height: 1.7; }
      .achievements li { margin-bottom: 6px; padding-left: 18px; position: relative; }
      .achievements li:before { content: "-"; position: absolute; left: 0; color: #ccc; }
      .education-item { margin-bottom: 22px; }
      .education-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 5px; }
      .degree { font-weight: 500; color: #1a1a1a; }
      .institution { color: #666; font-size: 0.95em; }
      .skills-list { color: #4a4a4a; line-height: 1.8; }
      .skill-group { margin-bottom: 12px; }
      .skill-label { font-weight: 500; color: #1a1a1a; display: inline; }
      @media (max-width: 768px) { body { padding: 40px 25px; } .company-header, .role-header, .education-header { flex-direction: column; gap: 5px; } .contact { flex-direction: column; gap: 8px; } }
    </style>

    <div class="container">
      <div class="header">
        <h1>Maria Carrasco</h1>
        <div class="subtitle">Software Engineering Leader</div>
        <div class="contact">
          <span>Berlin, Germany</span>
          <a href="mailto:kostspielig@gmail.com">kostspielig@gmail.com</a>
          <a href="http://github.com/kostspielig">github.com/kostspielig</a>
          <span>(+49) 17687090570</span>
        </div>
      </div>

      <div class="section">
        <h2 class="section-title">Experience</h2>

        <div class="experience-item">
          <div class="company-header">
            <div class="company-name">Elli - Volkswagen Group</div>
            <div class="date">2020 - Present</div>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Head of Software Engineering</div>
              <div class="date">2023 - Present</div>
            </div>
            <div class="description">
              Lead engineering organization building Europe's residential smart charging platform, managing 40+ engineers across product and platform teams. Direct reports include staff engineers and engineering managers.
            </div>
            <ul class="achievements">
              <li>Architected and scaled residential charging systems serving 100k+ users across 8 European markets, reducing charging costs by 30% through intelligent load optimization</li>
              <li>Built platform engineering capability from ground up, establishing mobile and web foundation teams that reduced feature delivery time by 60%</li>
              <li>Drive AI strategy for engineering productivity, spearheading adoption of AI-powered development tools that increased developer velocity by 35% and reduced code review cycles by 50%</li>
              <li>Own strategic technology partnerships with Google Cloud Platform and GitHub, managing relationships and co-creating initiatives including AI tooling pilot programs, quarterly hackathons, and joint innovation workshops</li>
              <li>Introduced FinOps practices across engineering organization, achieving 30% reduction in cloud infrastructure costs and €300k+ annual savings through optimization and governance</li>
              <li>Led technical due diligence and architecture strategy for GCP migration, influencing €1M+ infrastructure investment decision</li>
              <li>Redesigned engineering hiring process increasing offer acceptance rate from 40% to 75% while maintaining quality bar, growing team 3x in 18 months</li>
              <li>Established technical vision and quarterly OKR framework across engineering org, improving cross-team alignment and delivery predictability</li>
            </ul>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Principal Engineering Manager</div>
              <div class="date">2020 - 2023</div>
            </div>
            <div class="description">
              Led strategic initiatives during company's growth phase from startup to Volkswagen Group entity. Managed cross-functional teams and established engineering practices.
            </div>
            <ul class="achievements">
              <li>Drove organizational transformation during acquisition, managing communication strategy and maintaining team productivity through transition</li>
              <li>Established engineering excellence practices including code review standards, deployment pipelines, and incident management processes</li>
            </ul>
          </div>
        </div>

        <div class="experience-item">
          <div class="company-header">
            <div class="company-name">SoundCloud</div>
            <div class="date">2019 - 2022</div>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Engineering Manager, Payments & Subscriptions</div>
              <div class="date">2020 - 2022</div>
            </div>
            <div class="description">
              Managed engineering team responsible for monetization infrastructure supporting 175M+ users and 30M+ creators. Led 12 engineers across full stack.
            </div>
            <ul class="achievements">
              <li>Launched DJ Offline subscription tier generating €8M ARR in first year, handling payment processing across 15+ countries and payment methods</li>
              <li>Led PCI-DSS compliance initiative implementing 3DS2 authentication, reducing fraud by 45% while maintaining 99.9% payment success rate</li>
              <li>Built subscription management platform processing 2M+ transactions monthly with zero downtime (Ruby, Scala, TypeScript, MySQL)</li>
              <li>Designed engineering career framework and grew team from 6 to 12 engineers through strategic hiring, reducing time-to-productivity by 40%</li>
            </ul>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Senior Software Engineer, Payments</div>
              <div class="date">2019 - 2020</div>
            </div>
            <ul class="achievements">
              <li>Migrated legacy payment infrastructure to event-driven architecture using Clojure and Kafka, improving reliability from 98% to 99.9%</li>
              <li>Led technical design for subscription billing system handling complex pricing models and international tax compliance</li>
            </ul>
          </div>
        </div>

        <div class="experience-item">
          <div class="company-header">
            <div class="company-name">Zalando</div>
            <div class="date">2014 - 2019</div>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Engineering Manager, Shop Platform</div>
              <div class="date">2016 - 2019</div>
            </div>
            <div class="description">
              Led frontend platform team building core infrastructure serving 50M+ customers across 25 markets. Managed transition from monolith to microservices architecture.
            </div>
            <ul class="achievements">
              <li>Architected migration from PHP monolith to microservices-based frontend (Node.js, TypeScript, GraphQL), reducing page load time by 50% and enabling 10x team scaling</li>
              <li>Built developer platform and component library adopted by 200+ engineers, reducing new feature development time from weeks to days</li>
              <li>Designed custom tracking infrastructure replacing GTM, processing 1B+ events daily with 99.99% reliability (Go, DynamoDB, Kinesis)</li>
              <li>Established frontend engineering standards and practices across organization, mentoring 5 tech leads</li>
            </ul>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Software Engineer</div>
              <div class="date">2014 - 2016</div>
            </div>
            <ul class="achievements">
              <li>Developed real-time recommendation system for Zalando Lounge, increasing conversion rate by 18%</li>
              <li>Contributed to backend-for-frontend architecture pattern adoption, improving API performance by 3x</li>
            </ul>
          </div>
        </div>

        <div class="experience-item">
          <div class="company-header">
            <div class="company-name">Indra</div>
            <div class="date">2012 - 2014</div>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Software Consultant</div>
              <div class="date">2012 - 2014</div>
            </div>
            <ul class="achievements">
              <li>Delivered cloud infrastructure solutions for government and enterprise clients as part of R&D team</li>
              <li>Contributed to platform enabling SMEs to adopt cloud technology, serving 50+ organizations</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="section">
        <h2 class="section-title">Education</h2>

        <div class="education-item">
          <div class="degree">M.S. Information & Computer Science</div>
          <div class="institution">University of California, Irvine</div>
        </div>

        <div class="education-item">
          <div class="degree">M.Eng. Computer Engineering</div>
          <div class="institution">Universidad de Granada, Spain</div>
        </div>

        <div class="education-item">
          <div class="degree">Erasmus Exchange - Computer Science</div>
          <div class="institution">Brunel University, London</div>
        </div>
      </div>

      <div class="section">
        <h2 class="section-title">Technical Skills</h2>
        <div class="skills-list">
          <div class="skill-group">
            <h3 class="skill-label font-medium">Technical Leadership</h3>
            <ul class="achievements">
              <li>Engineering strategy, org design, tech roadmap ownership</li>
              <li>Agile delivery models, DevOps culture development, platform governance</li>
              <li>Budgeting for platforms and cloud operations</li>
            </ul>
          </div>

          <div class="skill-group">
            <h3 class="skill-label font-medium">Architecture Leadership</h3>
            <ul class="achievements">
              <li>Guide system design, platform standards, and API strategy</li>
              <li>Ensure reliability, security, and compliance across teams</li>
              <li>Guide major technology decisions and architectural direction</li>
              <li>Lead enterprise cloud adoption and infrastructure planning</li>
              <li>Align platform investments with business objectives</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="section">
        <h2 class="section-title">Courses / Certifications</h2>
        <div class="education-item">
          <div class="education-header">
            <div class="degree">2024-25</div>
            <div class="institution">Google Cloud Digital Leader Certification; Senior Leadership Training, Volkswagen</div>
          </div>
        </div>
        <div class="education-item">
          <div class="education-header">
            <div class="degree">2022-23</div>
            <div class="institution">Machine Learning Crash Course; Introduction to Big Data; Introduction to NoSQL Databases</div>
          </div>
        </div>
        <div class="education-item">
          <div class="education-header">
            <div class="degree">2019-22</div>
            <div class="institution">Sprint Manager Training program; Business Strategy and Leadership; LeadDev Together training programme</div>
          </div>
        </div>
      </div>
      <div class="section">
        <h2 class="section-title">Languages</h2>

        <div class="education-item">
          <div class="education-header">
            <div class="degree">German</div>
            <div class="institution">Advanced</div>
          </div>
        </div>

        <div class="education-item">
          <div class="education-header">
            <div class="degree">English</div>
            <div class="institution">Fluent</div>
          </div>
        </div>

        <div class="education-item">
          <div class="education-header">
            <div class="degree">Spanish</div>
            <div class="institution">Native</div>
          </div>
        </div>

        <div class="education-item">
          <div class="education-header">
            <div class="degree">Chinese</div>
            <div class="institution">Beginner</div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
