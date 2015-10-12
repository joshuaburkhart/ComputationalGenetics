module VCFRegex
  IS_INFO   = /^##INFO/
  IS_DATA   = /^[^#]+/
  INFO_VALS = /^##INFO.*ID=(?<iv_id>[^,]+).*Type=(?<iv_type>[^,]+).*Description="(?<iv_description>[^",]+)(.*range\s+\((?<iv_range>[^\)]+)|.*)/
  DATA_VALS = /^(?<dv_chrom>[^#\s]+)\s+(?<dv_pos>[^\s]+)\s+(?<dv_id>[^\s]+)\s+(?<dv_ref>[^\s]+)\s+(?<dv_alt>[^\s]+)\s+(?<dv_qual>[^\s]+)\s+(?<dv_filter>[^\s]+)\s+(?<dv_info>[^\s]+)\s+(?<dv_format>[^\s]+)\s+(?<dv_samples>.*)/
  META_DATA = /^##(?<md_key>[^\s=]+)\s*=\s*(?<md_value>[a-zA-Z0-9_.:\/]+)/
  GT_CALL   = /([0-9]\|[0-9])/
  REF_GT    = /(0\|0)/
  ALT_GT    = /(0\|[^0])|([^0]\|0)|([^0]\|[^0])/
end