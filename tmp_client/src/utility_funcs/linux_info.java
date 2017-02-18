package utility_funcs;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

public class linux_info {

	public static int cpu_usage(int interval) {
		Map<String, ?> map1 = linux_info.cpu_info();
		try {
			Thread.sleep(interval * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Map<String, ?> map2 = linux_info.cpu_info();
		
		long user1 = Long.parseLong(map1.get("user").toString());
		long nice1 = Long.parseLong(map1.get("nice").toString());
		long system1 = Long.parseLong(map1.get("system").toString());
		long idle1 = Long.parseLong(map1.get("idle").toString());
		
		long user2 = Long.parseLong(map2.get("user").toString());
		long nice2 = Long.parseLong(map2.get("nice").toString());
		long system2 = Long.parseLong(map2.get("system").toString());
		long idle2 = Long.parseLong(map2.get("idle").toString());

		long usage1 = user1 + system1 + nice1;
		long usage2 = user2 + system2 + nice2;
		float usage = usage1 - usage2;

		long total1 = user1 + nice1 + system1 + idle1;
		long total2 = user2 + nice2 + system2 + idle2;
		float total = total1 - total2;

		float cpusage = (usage / total) * 100;
		return (int) cpusage;
	}

	public static Map<String, ?> cpu_info() {
		InputStreamReader inputs = null;
		BufferedReader buffer = null;
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			inputs = new InputStreamReader(new FileInputStream("/proc/stat"));
			buffer = new BufferedReader(inputs);
			String line = "";
			while (true) {
				line = buffer.readLine();
				if (line == null) {
					break;
				}
				if (line.startsWith("cpu")) {
					StringTokenizer tokenizer = new StringTokenizer(line);
					List<String> temp = new ArrayList<String>();
					while (tokenizer.hasMoreElements()) {
						String value = tokenizer.nextToken();
						temp.add(value);
					}
					map.put("user", temp.get(1));
					map.put("nice", temp.get(2));
					map.put("system", temp.get(3));
					map.put("idle", temp.get(4));
					map.put("iowait", temp.get(5));
					map.put("irq", temp.get(6));
					map.put("softirq", temp.get(7));
					map.put("stealstolen", temp.get(8));
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				buffer.close();
				inputs.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return map;
	}

	public static int memory_usage() {
		Map<String, Object> map = new HashMap<String, Object>();
		InputStreamReader inputs = null;
		BufferedReader buffer = null;
		try {
			inputs = new InputStreamReader(new FileInputStream("/proc/meminfo"));
			buffer = new BufferedReader(inputs);
			String line = "";
			while (true) {
				line = buffer.readLine();
				if (line == null)
					break;
				int beginIndex = 0;
				int endIndex = line.indexOf(":");
				if (endIndex != -1) {
					String key = line.substring(beginIndex, endIndex);
					beginIndex = endIndex + 1;
					endIndex = line.length();
					String memory = line.substring(beginIndex, endIndex);
					String value = memory.replace("kB", "").trim();
					map.put(key, value);
				}
			}

			long memTotal = Long.parseLong(map.get("MemTotal").toString());
			long memFree = Long.parseLong(map.get("MemFree").toString());
			long buffers = Long.parseLong(map.get("Buffers").toString());
			long cached = Long.parseLong(map.get("Cached").toString());
			double usage = (double) (memTotal - memFree - buffers - cached) / memTotal * 100;
			return (int) usage;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				buffer.close();
				inputs.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return 0;
	}

	public static void main(String argv[]) {
		System.out.println(linux_info.cpu_info().toString());
		System.out.println(linux_info.cpu_usage(10));
		System.out.println(linux_info.memory_usage());
	}
}