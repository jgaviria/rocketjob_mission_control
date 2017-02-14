module RocketJobMissionControl
  class RunningJobsDatatable < JobsDatatable
    DISPLAY_COLUMNS = %w[_type description percent_complete priority started_at]
    SORT_COLUMNS    = %w[_type description percent_complete priority started_at]

    private

    def map(job)
      {
        '0'           => class_with_link(job),
        '1'           => h(job.description.try(:truncate, 50)),
        '2'           => progress(job),
        '3'           => h(job.priority),
        '4'           => h(started(job)),
        '5'           => action_buttons(job),
        'DT_RowClass' => "card callout callout-#{job.state}"
      }
    end

    def sort_column(index)
      SORT_COLUMNS[index.to_i]
    end

    def progress(job)
      if (sub_state = job.attributes['sub_state']) && [:before, :after].include?(sub_state)
        <<-EOS
          <div class="job-status">
            <div class="job-state">
              <div class="left">Batch</div>
              <div class="right running">#{sub_state}</div>
            </div>
          </div>
        EOS
      else
        <<-EOS
          <div class='progress'>
            <div class='progress-bar' style="width: #{job.percent_complete}%;", title="#{job.percent_complete}% complete."></div>
          </div>
        EOS
      end
    end

    def started(job)
      "#{RocketJob.seconds_as_duration(Time.now - job.started_at)} ago" if job.started_at
    end
  end
end
