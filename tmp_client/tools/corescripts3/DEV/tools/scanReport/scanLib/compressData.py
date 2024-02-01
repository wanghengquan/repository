#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 4:07 PM 4/12/2023
  file: compressData.py
  author: Shawn Yan
Description:

"""
import re
from statistics import geometric_mean
from . import utils


class CompressData(object):
    def __init__(self, source_data_files, tidy_file_data_dict, ignore_clock, care_clock, fmax_opt):
        self.source_data_files = source_data_files
        self.tidy_file_data_dict = tidy_file_data_dict
        self.ignore_clock = ignore_clock
        self.care_clock = care_clock
        self.single_line_data = dict()
        self.fmax_opt = fmax_opt

    def get_compressed_data(self):
        null_keys = list()
        for k, v in list(self.single_line_data.items()):
            if v is None:
                null_keys.append(k)
        for k in null_keys:
            self.single_line_data.pop(k)
        return self.single_line_data

    def process(self):
        self.get_overall_status()
        self.get_other_data()
        self.more_time2seconds()
        self.more_flow_runtime()
        self.more_cpu_time()
        self.more_fmax_value()

    def get_overall_status(self):
        """ check folders endswith _Failed or not
        """
        overall_keys = list(self.source_data_files.keys())
        failed_keys = list()
        for foo in overall_keys:
            if foo.endswith("_Failed"):
                failed_keys.append(foo)
        total_number = len(overall_keys)
        failed_number = len(failed_keys)
        passed_number = total_number - failed_number
        if total_number == 0:
            sts_msg = "NotFoundData"
        elif failed_number == total_number:
            sts_msg = "failed({})".format(failed_number)
        elif failed_number == 0:
            sts_msg = "passed({})".format(total_number)
        else:
            sts_msg = "total({});passed({});failed({})".format(total_number, passed_number, failed_number)
        self.single_line_data["overall_status"] = sts_msg

    def skip_none_if_necessary(self, new_data):
        for k, v in list(new_data.items()):
            now_v = self.single_line_data.get(k)
            if now_v and not v:
                continue
            self.single_line_data[k] = v

    def get_other_data(self):
        self.more_timing_data()
        for twr_ht_or_lt, twr_best_data in list(self.timing_data.items()):
            best_fmax_data = twr_best_data.get("for_fmax")
            best_geo_data = twr_best_data.get("for_geo")
            if best_fmax_data:
                for pb_or_target, raw_files in list(self.source_data_files.items()):
                    if best_fmax_data.get("twr_file", "twr-file") in raw_files:
                        real_data = [self.tidy_file_data_dict.get(item) for item in raw_files]
                        for foo in real_data:
                            if foo.get(twr_ht_or_lt):
                                self.single_line_data.update(best_fmax_data)
                                self.single_line_data["best_fmax_point"] = pb_or_target
                            else:
                                self.skip_none_if_necessary(foo)
                for pb_or_target, raw_files in list(self.source_data_files.items()):
                    if best_geo_data.get("twr_file", "twr-file") in raw_files:
                        self.single_line_data["best_geo_point"] = pb_or_target
                        self.single_line_data.update(best_geo_data)
            else:
                for pb_or_target, raw_files in list(self.source_data_files.items()):
                    real_data = [self.tidy_file_data_dict.get(item) for item in raw_files]
                    for foo in real_data:
                        self.skip_none_if_necessary(foo)
        for no_show_title in ["twr_file"] + list(self.timing_data.keys()):
            if no_show_title in self.single_line_data:
                self.single_line_data.pop(no_show_title)

    def more_timing_data(self):
        self.timing_data = dict(twr_data=dict(), ht_twr_data=dict(), lt_twr_data=dict())
        for k, v in list(self.timing_data.items()):
            self.timing_data[k] = dict(for_fmax=self.get_best_fmax_data(k, for_geo=False),
                                       for_geo=self.get_best_fmax_data(k, for_geo=True))

    def get_best_fmax_data(self, my_twr_key, for_geo=True):
        hold_slack_value_list = list()
        first_fmax_data = list()
        ff_key = "float_fmax"
        for rpt_file, rpt_data in list(self.tidy_file_data_dict.items()):
            twr_data = rpt_data.get(my_twr_key)
            if not twr_data:
                continue
            point_data_list = list()
            for clk_name, clk_data in list(twr_data.items()):
                if clk_name == "special_ht_and_lt":
                    self.single_line_data.update(clk_data)
                    continue
                if self.care_clock:
                    if clk_name not in self.care_clock:
                        continue
                elif self.ignore_clock and (clk_name in self.ignore_clock):
                    continue
                point_data = dict()
                fmax = clk_data.get("fmax")
                try:
                    float_fmax = float(fmax)
                except (TypeError, ValueError):
                    float_fmax = ""
                point_data["clk_name"] = clk_name
                point_data[ff_key] = float_fmax
                point_data["twr_file"] = rpt_file
                point_data.update(clk_data)
                for another_key, another_value in list(rpt_data.items()):  # for constraint_coverage alike
                    if another_key == "hold_worst_slack":
                        if another_value:
                            hold_slack_value_list.append(another_value)
                        continue
                    if another_key not in list(self.timing_data.keys()):
                        point_data[another_key] = another_value
                point_data_list.append(point_data)
            first_fmax_data.append(point_data_list)
        final_data = dict()
        for foo in first_fmax_data:
            float_fmax_list = [item.get(ff_key) for item in foo if isinstance(item.get(ff_key), float)]
            if not float_fmax_list:
                continue
            if for_geo:
                geo_value = geometric_mean(float_fmax_list)
                geo_value = round(geo_value, 3)
                final_data[geo_value] = dict(twr_file=foo[0].get("twr_file"), geo_fmax=str(geo_value))
            else:
                min_fmax = min(float_fmax_list)
                min_index = float_fmax_list.index(min_fmax)
                final_data[min_fmax] = foo[min_index]
        if final_data:
            max_one = max(list(final_data.keys()))
            res = final_data.get(max_one)
            if ff_key in res:
                res.pop(ff_key)
            #
            real_res = dict()
            for k, v in list(res.items()):
                if k == "twr_file":
                    pass
                elif my_twr_key.startswith("ht_"):
                    k = "ht_{}".format(k)
                elif my_twr_key.startswith("lt_"):
                    k = "lt_{}".format(k)
                real_res[k] = v
            #
            if hold_slack_value_list:
                x = dict()
                for foo in hold_slack_value_list:
                    x[float(foo)] = foo
                real_res["hold_worst_slack"] = x.get(max(list(x.keys())))
            #
            return real_res
        return dict()

    def more_time2seconds(self):
        for k, v in list(self.single_line_data.items()):
            if k.endswith("_time"):
                self.single_line_data[k] = utils.time2secs(v)

    @staticmethod
    def seconds2hms(seconds):
        h, ms = divmod(seconds, 60 * 60)
        m, s = divmod(ms, 60)
        hms_list = list()
        start = 0
        for (num, unit_name) in ((h, "hr"), (m, "min"), (s, "sec")):
            if not start:
                start = num
            if start:
                hms_list.extend([str(num), unit_name if num <= 1 else unit_name + "s"])
        return " ".join(hms_list)

    def more_flow_runtime(self):
        for k, v in list(self.single_line_data.items()):
            if k == "flow_runtime":
                try:
                    seconds = int(float(v))
                    self.single_line_data[k] = self.seconds2hms(seconds)
                    self.single_line_data["flow_runtime_secs"] = str(seconds)
                except (TypeError, ValueError):
                    pass

    def more_cpu_time(self):
        must_cpu_titles = ("lse_cpu_time", "synplify_cpu_time", "mapper_cpu_time", "par_cpu_time")
        must_cpu_time_values = [self.single_line_data.get(item) for item in must_cpu_titles]
        synthesis_time = must_cpu_time_values[0] or must_cpu_time_values[1]
        mapper_time, par_time = must_cpu_time_values[2], must_cpu_time_values[3]
        if synthesis_time and mapper_time and par_time:
            try:
                _eq = "{} + {} + {}".format(synthesis_time, mapper_time, par_time)
                self.single_line_data["total_cpu_time"] = str(eval(_eq))
            except TypeError:
                pass
        for foo in ("lse_cpu_time", "synplify_cpu_time"):
            chk_value = self.single_line_data.get(foo)
            if chk_value:
                self.single_line_data["synthesis_cpu_time"] = chk_value
                break

    def more_fmax_value(self):
        ht_d, lt_d = self.single_line_data.get("ht_degree"), self.single_line_data.get("lt_degree")
        ht_fmax_value = self.single_line_data.get("ht_fmax")
        lt_fmax_value = self.single_line_data.get("lt_fmax")
        if ht_d and lt_d:
            real_fmax_opt = ""
            if ht_d == lt_d:  # ond data only
                real_fmax_opt = "ht"
            else:
                if self.fmax_opt in ("ht", "lt"):
                    real_fmax_opt = self.fmax_opt
                else:
                    if ht_fmax_value and lt_fmax_value:
                        x_dict = dict()
                        x_dict[float(lt_fmax_value)] = "lt"  # same value ues lt data
                        x_dict[float(ht_fmax_value)] = "ht"
                        x_keys = list(x_dict.keys())
                        if self.fmax_opt == "max":
                            real_fmax_opt = x_dict[max(x_keys)]
                        else:
                            real_fmax_opt = x_dict[min(x_keys)]
            if not real_fmax_opt:
                return
            # DO NOT use ht_ and lt_ as normal field's prefix except timing data
            real_fmax_opt += "_"
            new_data = dict()
            p_sub = re.compile("^[lh]t_")
            for k, v in list(self.single_line_data.items()):
                if k.startswith(real_fmax_opt) and not k.endswith("degree"):
                    new_k = p_sub.sub("", k)
                    new_data[new_k] = v
            self.single_line_data.update(new_data)
