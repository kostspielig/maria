defmodule MariaWeb.CvLive do
  use MariaWeb, :live_view_basic

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body { font-family: system-ui, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; line-height: 1.5; color: #111; background: #fff; padding: 44px 40px; font-size: 17px; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; }
      .container { max-width: 800px; margin: 0 auto; }
      .header { margin-bottom: 30px; padding-bottom: 15px; }
      .header-top { display: flex; justify-content: space-between; align-items: flex-start; }
      .header-left { display: flex; flex-direction: column; }
      .name { font-family: 'Racing Sans One', cursive; font-size: 36px; font-weight: 400; line-height: 1.1; margin-bottom: 5px; }
      .subtitle { font-size: 18px; color: #444; margin-top: 0; }
      .contact-info { display: flex; flex-direction: column; gap: 8px; text-align: right; font-size: 15px; color: #333; line-height: 1.2; }
      .contact-info div { display: flex; align-items: center; justify-content: flex-end; gap: 6px; }
      .contact-info a, .contact-info span { color: #666; font-style: italic; }
      .contact-info a { text-decoration: none; }
      .contact-info a:hover { color: #3aadec; }
      .contact-icon { width: 16px; height: 16px; color: #666; }
      .section { margin: 18px 0 24px 0; }
      .section-title { font-size: 15px; text-transform: uppercase; letter-spacing: 0.12em; color: #111; margin: 12px 0 12px 0; border-bottom: 2px solid #333; padding-bottom: 4px; font-weight: 700; }

      .experience-item { margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid #ddd; }
      .experience-item:last-child { border-bottom: none; padding-bottom: 0; margin-bottom: 0; }
      .company-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 6px; }
      .company-name { font-size: 17px; font-weight: 700; }
      .company-location { font-weight: 400; color: #666; margin-left: 4px; font-size: 14px; }
      .date { color: #333; font-size: 14px; font-variant-numeric: tabular-nums; letter-spacing: 0.02em; }

      .role-title { font-size: 16px; font-weight: 700; color: #444; margin-bottom: 6px; display: flex; align-items: baseline; gap: 10px; }
      .role-title .date { font-weight: 400; font-size: 13px; color: #666; font-variant-numeric: tabular-nums; }
      .description { color: #222; font-size: 16px; margin-bottom: 10px; }
      .achievements { margin-left: 22px; margin-bottom: 14px; }
      .achievements li { margin-bottom: 8px; list-style: disc; font-size: 15px; }
      .achievements.inline { display: flex; flex-wrap: wrap; gap: 20px; margin-left: 0; list-style: none; }
      .achievements.inline li { margin-bottom: 0; display: flex; align-items: center; }
      .achievements.inline li::before { content: "•"; margin-right: 8px; }
      .level { color: #666; font-weight: 400; margin-left: 4px; }
      .tech-stack { font-size: 15px; color: #444; margin-top: 6px; }
      .tech-stack strong { font-weight: 600; color: #111; }
      .skill-label { font-size: 16px; font-weight: 600; margin-bottom: 8px; }

      .education-item { margin-bottom: 12px; }
      .education-item .description { margin-bottom: 2px; }
      .education-header { display: flex; justify-content: flex-start; align-items: baseline; gap: 24px; }
      .education-header .degree { white-space: nowrap; flex-shrink: 0; }
      .degree { font-weight: 700; font-size: 17px; }
      .institution { color: #444; font-weight: 700; font-size: 16px; margin-bottom: 4px; }

      .small { font-size: 14px; color: #444; }
      .small .achievements li { margin-bottom: 2px; }

      @media (max-width: 768px) { body { padding: 20px; } .header-top { flex-direction: column; align-items: flex-start; gap: 12px; } .contact-info { text-align: left; margin-top: 10px; } .contact-info div { justify-content: flex-start; } .company-location { display: block; margin-left: 0; margin-top: 2px; } }

      @media print {
        body { padding: 0; font-size: 12px; }
        .container { max-width: 100%; width: 100%; }
        .header-top { flex-direction: row; justify-content: space-between; align-items: flex-start; }
        .contact-info { text-align: right; margin-top: 0; }
        .contact-info div { justify-content: flex-end; }
        a, .contact-info span { text-decoration: none; color: #666; font-style: italic; }
        .experience-item, .education-item, .skill-group { break-inside: avoid; page-break-inside: avoid; }
        .page-break { break-before: page; page-break-before: always; }
      }
    </style>

    <div class="container">
      <div class="header">
        <div class="header-top">
          <div class="header-left">
            <div class="name">Maria Carrasco</div>
            <div class="subtitle">Software Engineering Leader</div>
          </div>
          <div class="contact-info">
            <div>
              <svg class="contact-icon" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/></svg>
              <a href="https://www.linkedin.com/in/kostspielig/">/in/kostspielig</a>
            </div>
            <div>
              <.icon name="hero-envelope" class="contact-icon" />
              <a href="mailto:kostspielig@gmail.com">kostspielig@gmail.com</a>
            </div>
            <div>
              <.icon name="hero-phone" class="contact-icon" />
              <a href="tel:+4917687090570">+49 176 87090570</a>
            </div>
            <div>
              <.icon name="hero-map-pin" class="contact-icon" />
              <span>Berlin, Germany</span>
            </div>
          </div>
        </div>
      </div>

      <div class="section">
        <h2 class="section-title">Experience</h2>

        <div class="experience-item">
          <div class="company-header">
            <div class="company-name">Volkswagen Group Charging <span class="company-location">Remote, Germany</span></div>
            <div class="date">Feb 2023 – Present</div>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Head of Software Engineering <span class="date">Jan 2024 – Present</span></div>
            </div>
            <div class="description">
              Lead engineering teams on residential smart charging solutions and core platform, managing 25+ engineers across product and platform teams. Direct reports include (staff) engineers and engineering managers.
            </div>
            <ul class="achievements">
              <li>Built platform engineering capability from ground up, establishing mobile and web foundation teams that doubled release frequency and improved system reliability</li>
              <li>Established and renegotiated strategic technology partnerships across GCP, GitHub, Amplitude and Apigee, securing enterprise agreements with 50-70% cost reductions through multi-year contracts and cross-organizational leverage within Volkswagen Group</li>
              <li>Own strategic technology partnerships with Google Cloud Platform and GitHub, managing relationships and co-creating initiatives including AI tooling pilot programs, quarterly hackathons, and joint innovation workshops</li>
              <li>Drive AI strategy for engineering productivity, spearheading adoption of AI-powered development tools that increased developer velocity by 35% and reduced code review cycles by 50%</li>
              <li>Introduced FinOps practices across engineering organization, achieving 30% reduction in cloud infrastructure costs and €300k+ annual savings through optimization and governance</li>
              <li>Led technical due diligence and architecture strategy for GCP migration, influencing €1M+ infrastructure investment decision</li>
            </ul>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Principal Engineering Manager <span class="date">Feb 2023 – Dec 2023</span></div>
            </div>
            <div class="description">
              Led strategic initiatives during company's growth phase. Managed cross-functional teams and shaped engineering practices.
            </div>
            <ul class="achievements">
              <li>Redesigned engineering hiring process increasing offer acceptance rate from 40% to 75% while maintaining quality bar, growing team 4x (from 20 to 80+ people) in 12 months</li>
              <li>Drove organizational transformation during internalization, managing communication strategy and maintaining team productivity through transition</li>
            </ul>
            <div class="tech-stack">
              <strong>Tech Stack:</strong> Typescript, Node.js, Postgres, GCP, Terraform, Kubernetes
            </div>
          </div>
        </div>

        <div class="experience-item">
          <div class="company-header">
            <div class="company-name">SoundCloud <span class="company-location">Berlin, Germany</span></div>
            <div class="date">Mar 2019 – Aug 2022</div>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Engineering Manager, Payments & Subscriptions <span class="date">Oct 2019 – Aug 2022</span></div>
            </div>
            <div class="description">
              Managed engineering teams responsible for monetization infrastructure supporting 175M+ users and 30M+ creators. Led 12+ engineers across 2 full stack teams.
            </div>
            <ul class="achievements">
              <li>Led the hiring and onboarding of new developers, establishing a dedicated payments team to drive the modernization and expansion of the payment platform.</li>
              <li>Launched 2 new subscription tiers, handling payment processing across 15+ countries and payment methods</li>
              <li>Led the migration from a legacy Rails payment system to a modern Scala architecture, integrating an external payment provider and restructuring the payment workflow for scalability and flexibility.</li>
            </ul>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Senior Software Engineer, Payments <span class="date">Mar 2019 – Oct 2019</span></div>
            </div>
            <ul class="achievements">

              <li>Led PCI-DSS compliance initiative implementing 3DS2 authentication, reducing fraud by 45% while maintaining 99.9% payment success rate</li>
              <li>Migrated to Adyen’s new Web Checkout, integrating four additional payment methods and driving a double‑digit increase in conversions.</li>
              <li>Mentored junior engineers across teams, supporting their development and growth.</li>
            </ul>
            <div class="tech-stack">
              <strong>Tech Stack:</strong> Scala, Ruby on Rails, Typescript, React, Node.js, AWS
            </div>
          </div>
        </div>

        <div class="experience-item">
          <div class="company-header">
            <div class="company-name">Zalando <span class="company-location">Berlin, Germany</span></div>
            <div class="date">Sep 2014 – Feb 2019</div>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Senior Software Engineer</div>
            </div>
            <ul class="achievements">
              <li>Architected and launched Zalandoʼs next-generation micro-frontend platform, scaling adoption from 7 teams to over 30, significantly improving modularity and maintainability</li>
              <li>Designed custom tracking infrastructure replacing GTM, processing 1B+ events daily with 99.99% reliability (Go, DynamoDB, Kinesis)</li>
              <li>Architected migration from PHP monolith to microservices-based frontend (Node.js, TypeScript, GraphQL), reducing page load time by 50% and enabling 10x team scaling</li>
              <li>Developed real-time recommendation system for Zalando Lounge, increasing conversion rate by 18%</li>
            </ul>
            <div class="tech-stack">
              <strong>Tech Stack:</strong> Node.js, TypeScript, React, GraphQL, AWS, Kubernetes, Golang, DynamoDB, Kinesis
            </div>
          </div>
        </div>

        <div class="experience-item">
          <div class="company-header">
            <div class="company-name">Various Tech Companies <span class="company-location">Madrid, Spain</span></div>
            <div class="date">Jul 2011 – Aug 2014</div>
          </div>

          <div class="role">
            <div class="role-header">
              <div class="role-title">Software Engineer</div>
            </div>
            <ul class="achievements">
              <li>Delivered cloud infrastructure solutions for government and enterprise clients as part of R&D team</li>
              <li>Contributed to platform enabling SMEs to adopt cloud technology, serving 50+ organizations</li>
            </ul>
            <div class="tech-stack">
              <strong>Tech Stack:</strong> PHP, JavaScript, React-like Frameworks, Azure
            </div>
          </div>
        </div>
      </div>

      <div class="section">
        <h2 class="section-title">Education</h2>

        <div class="education-item">
          <div class="degree">University of California, Irvine, USA</div>
          <div class="institution">M.S. Information & Computer Science</div>
          <div class="description">Completed a master's thesis on user-centric information retrieval and pursued advanced coursework in human-computer interaction, scalable software engineering, and search systems.</div>
          <div class="small">
            <ul class="achievements">
              <li>Dean's Honor List — awarded for exceptional academic performance and sustained achievement</li>
            </ul>
          </div>
        </div>

        <div class="education-item">
          <div class="degree">Universidad de Granada, Spain</div>
          <div class="institution">M.Eng. Computer Engineering</div>
          <div class="description">Master's level (5 years) degree in Computer Science and Software Engineering — 300 ECTS credits.</div>
          <div class="small">
            <ul class="achievements">
              <li>Awarded Erasmus exchange to UCI as one of the top 5 students selected from the university</li>
              <li>Excellence in Academic Records — conferred to the single top student in each graduating cohort</li>
            </ul>
          </div>
        </div>

        <div class="education-item">
          <div class="degree">Brunel University, London, UK</div>
          <div class="institution">Computer Science (Erasmus Exchange)</div>
        </div>
      </div>

      <div class="section">
        <h2 class="section-title">Skills</h2>
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

          <div class="skill-group">
            <h3 class="skill-label font-medium">Languages</h3>
            <ul class="achievements inline">
              <li>English <span class="level">(Fluent)</span></li>
              <li>Spanish <span class="level">(Native)</span></li>
              <li>German <span class="level">(Advanced)</span></li>
              <li>Chinese <span class="level">(Beginner)</span></li>
            </ul>
          </div>
        </div>
      </div>

      <div class="section">
        <h2 class="section-title">Courses / Certifications</h2>
        <div class="education-item">
          <div class="education-header">
            <div class="degree">2024–25</div>
            <div class="institution">Google Cloud Digital Leader Certification; Senior Leadership Training, Volkswagen</div>
          </div>
        </div>
        <div class="education-item">
          <div class="education-header">
            <div class="degree">2022–23</div>
            <div class="institution">Machine Learning Crash Course; Introduction to Big Data; Introduction to NoSQL Databases</div>
          </div>
        </div>
        <div class="education-item">
          <div class="education-header">
            <div class="degree">2019–22</div>
            <div class="institution">Sprint Manager Training program; Business Strategy and Leadership; LeadDev Together training program</div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
