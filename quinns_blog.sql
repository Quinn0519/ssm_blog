-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: quinns_blog
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article` (
  `article_id` int NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `article_user_id` int unsigned DEFAULT NULL COMMENT '用户ID',
  `article_title` varchar(255) DEFAULT NULL COMMENT '标题',
  `article_content` mediumtext COMMENT '内容',
  `article_update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `article_create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `article_summary` text COMMENT '摘要',
  `article_thumbnail` varchar(255) DEFAULT NULL COMMENT '缩略图',
  `article_status` int unsigned DEFAULT NULL,
  PRIMARY KEY (`article_id`)
) ENGINE=MyISAM AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article`
--

LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` VALUES (61,1,'GPUs in the task manager（任务管理器中的GPU）','<p style=\"text-align: justify;\">原文链接：<a target=\"_blank\" rel=\"noopener\" href=\"https://devblogs.microsoft.com/directx/gpus-in-the-task-manager/\" data-pjax-state=\"\">GPUs in the task manager - DirectX Developer Blog (microsoft.com)</a></p><p style=\"text-align: justify;\">Bryan L 发布于 2017 年 7 月 21 日</p><p style=\"text-align: justify;\">下面的帖子来自Steve Pronovost，他是我们负责GPU调度和内存管理的首席工程师。</p><blockquote style=\"text-align: justify;\"><p>The below posting is from Steve Pronovost, our lead engineer responsible for the GPU scheduler and memory manager.</p></blockquote><h2 id=\"任务管理器中的GPU（GPUs-in-the-Task-Manager）\" style=\"text-align: justify;\">任务管理器中的GPU（GPUs in the Task Manager）</h2><p style=\"text-align: justify;\">我们很高兴在任务管理器中引入对GPU性能数据的支持。这是用户的需求功能之一，我们听取了用户的建议。GPU终于在这个古老的性能工具上首次亮相。要立即使用这个功能，你可以加入<a target=\"_blank\" rel=\"noopener\" href=\"https://insider.windows.com/\" data-pjax-state=\"\">Windows内部程序</a>。或者，你可以等待<a target=\"_blank\" rel=\"noopener\" href=\"https://www.microsoft.com/en-us/windows/upcoming-features\" data-pjax-state=\"\">Windows Fall Creator’s Update.</a></p><blockquote style=\"text-align: justify;\"><p>We’re excited to introduce support for GPU performance data in the Task Manager. This is one of the features you have often requested, and we listened. The GPU is finally making its debut in this venerable performance tool. To see this feature right away, you can join the&nbsp;<a target=\"_blank\" rel=\"noopener\" href=\"https://insider.windows.com/\" data-pjax-state=\"\">Windows Insider Program</a>. Or, you can wait for the&nbsp;<a target=\"_blank\" rel=\"noopener\" href=\"https://www.microsoft.com/en-us/windows/upcoming-features\" data-pjax-state=\"\">Windows Fall Creator’s Update.</a></p></blockquote><p style=\"text-align: justify;\">要了解所有的GPU性能数据，了解Windows如何使用GPU是很有帮助的。本博客将深入研究这些细节，并解释任务管理器的GPU性能数据是如何活跃起来的。这个博客可能会有点长，但我们还是希望你能喜欢它。</p><blockquote style=\"text-align: justify;\"><p>To understand all the GPU performance data, its helpful to know how Windows uses a GPUs. This blog dives into these details and explains how the Task Manager’s GPU performance data comes alive. This blog is going to be a bit long, but we hope you enjoy it nonetheless.</p></blockquote><h3 id=\"系统要求（System-Requirements）\" style=\"text-align: justify;\">系统要求（System Requirements）</h3><p style=\"text-align: justify;\">在Windows中，GPU 通过Windows显示驱动程序模型 (WDDM) 公开。WDDM的核心是图形内核，它负责在所有正在运行的进程（每个应用程序都有一个或多个进程）之间抽象、管理和共享GPU。图形内核包括一个GPU调度程序 (VidSch) 以及一个显存管理器 (VidMm)。VidSch负责将GPU的各种引擎调度到想要使用它们的进程，并在它们之间仲裁和优先访问。VidMm负责管理GPU使用的所有内存，包括VRAM（显卡上的内存）以及GPU直接访问的主DRAM（系统内存）的页面。为系统中的每个GPU实例化一个VidMm和VidSch实例。</p><blockquote style=\"text-align: justify;\"><p>In Windows, the GPU is exposed through the Windows Display Driver Model (WDDM). At the heart of WDDM is the Graphics Kernel, which is responsible for abstracting, managing, and sharing the GPU among all running processes (each application has one or more processes). The Graphics Kernel includes a GPU scheduler (VidSch) as well as a video memory manager (VidMm). VidSch is responsible for scheduling the various engines of the GPU to processes wanting to use them and to arbitrate and prioritize access among them. VidMm is responsible for managing all memory used by the GPU, including both VRAM (the memory on your graphics card) as well as pages of main DRAM (system memory) directly accessed by the GPU. An instance of VidMm and VidSch is instantiated for each GPU in your system.</p></blockquote><p style=\"text-align: justify;\">任务管理器中的数据直接从VidSch和VidMm收集。因此，无论使用什么API，无论是Microsoft DirectX API、OpenGL、OpenCL、Vulkan 还是专有API，例如AMD的Mantle或Nvidia的CUDA，都可以获得GPU的性能数据。此外，由于VidMm和VidSch是决定使用GPU资源的实际代理，因此任务管理器中的数据将比许多其他实用程序更准确，这些实用程序通常会尽力做出一些“预测”，因为它们无法访问实际的数据。</p><blockquote style=\"text-align: justify;\"><p>The data in the Task Manager is gathered directly from VidSch and VidMm. As such, performance data for the GPU is available no matter what API is being used, whether it be Microsoft DirectX API, OpenGL, OpenCL, Vulkan or even proprietary API such as AMD’s Mantle or Nvidia’s CUDA. Further, because VidMm and VidSch are the actual agents making decisions about using GPU resources, the data in the Task Manager will be more accurate than many other utilities, which often do their best to make intelligent guesses since they do not have access to the actual data.</p></blockquote><p style=\"text-align: justify;\">任务管理器的GPU性能数据需要支持WDDM 2.0或更高版本的GPU驱动程序。WDDMv2是在Windows 10的原始版本中引入的，并且受到大约70%的Windows 10用户的支持。如果您不确定您的GPU驱动程序使用的WDDM版本，您可以使用作为Windows一部分提供的dxdiag实用程序来查找。要启动dxdiag，请打开开始菜单并输入dxdiag.exe。查看<em>Display</em>选项卡下的<em>Drivers</em>部分中的<em>Driver Model</em>。不幸的是，如果您在较旧的WDDMv1.x GPU上运行，任务管理器将不会为您显示GPU数据。</p><blockquote style=\"text-align: justify;\"><p>The Task Manager’s GPU performance data requires a GPU driver that supports WDDM version 2.0 or above. WDDMv2 was introduced with the original release of Windows 10 and is supported by roughly 70% of the Windows 10 population. If you are unsure of the WDDM version your GPU driver is using, you may use the dxdiag utility that ships as part of windows to find out. To launch dxdiag open the start menu and simply type dxdiag.exe. Look under the&nbsp;<em>Display</em>&nbsp;tab, in the&nbsp;<em>Drivers</em>&nbsp;section for the&nbsp;<em>Driver Model</em>. Unfortunately, if you are running on an older WDDMv1.x GPU, the Task Manager will not be displaying GPU data for you.</p></blockquote><h3 id=\"性能选项卡（Performance-Tab）\" style=\"text-align: justify;\">性能选项卡（Performance Tab）</h3><p style=\"text-align: justify;\">在“性能”选项卡下，您将找到所有进程汇总的所有支持WDDMv2的GPU的性能数据。</p><blockquote style=\"text-align: justify;\"><p>Under the Performance tab you’ll find performance data, aggregated across all processes, for all of your WDDMv2 capable GPUs.</p></blockquote><p style=\"text-align: justify;\"><img src=\"https://raw.githubusercontent.com/Direct5dom/imageDB/main/202205081143769.png\" alt=\"\"></p><h4 id=\"GPU和交火-SLI（GPUs-and-Links）\" style=\"text-align: justify;\">GPU和交火/SLI（GPUs and Links）</h4><p style=\"text-align: justify;\">在左侧的面板上，您可以看到系统中的GPU列表。其中GPU #是一个任务管理器概念，用于任务管理器UI的其他部分，以简洁的方式代表特定的GPU。因此，不必直接说Intel® HD Graphics 530来指代上面屏幕截图中的Intel GPU，我们可以简单地说GPU 0。当存在多个GPU时，它们按其物理位置排序（PCI 总线/设备/ 功能）。</p><blockquote style=\"text-align: justify;\"><p>On the left panel, you’ll see the list of GPUs in your system. The GPU # is a Task Manager concept and used in other parts of the Task Manager UI to reference specific GPU in a concise way. So instead of having to say Intel® HD Graphics 530 to reference the Intel GPU in the above screenshot, we can simply say GPU 0. When multiple GPUs are present, they are ordered by their physical location (PCI bus/device/function).</p></blockquote><p style=\"text-align: justify;\">Windows支持将多个GPU链接在一起以创建更大、更强大的逻辑GPU。链接的GPU共享一个VidMm和VidSch实例，因此可以非常紧密地协作，包括读取和写入彼此的VRAM。您可能会更熟悉我们合作伙伴的链接商业名称，即Nvidia SLI和AMD Crossfire。当GPU链接在一起时，任务管理器将为每个链接分配一个链接编号，并识别属于其中一部分的GPU。任务管理器可让您检查链接中每个物理GPU的状态，从而观察您的游戏如何充分利用每个GPU。</p><blockquote style=\"text-align: justify;\"><p>Windows supports linking multiple GPUs together to create a larger and more powerful logical GPU. Linked GPUs share a single instance of VidMm and VidSch, and as a result, can cooperate very closely, including reading and writing to each other’s VRAM. You’ll probably be more familiar with our partners’ commercial name for linking, namely Nvidia SLI and AMD Crossfire. When GPUs are linked together, the Task Manager will assign a Link # for each link and identify the GPUs which are part of it. Task Manager lets you inspect the state of each physical GPU in a link allowing you to observe how well your game is taking advantage of each GPU.</p></blockquote><h4 id=\"GPU利用率（GPU-Utilization）\" style=\"text-align: justify;\">GPU利用率（GPU Utilization）</h4><p style=\"text-align: justify;\">在右侧面板的顶部，您将找到有关各种GPU引擎的利用率信息。</p><blockquote style=\"text-align: justify;\"><p>At the top of the right panel you’ll find utilization information about the various GPU engines.</p></blockquote><p style=\"text-align: justify;\">GPU引擎代表GPU上的一个独立硅单元，可以调度并且可以彼此并行运行。例如，Copy引擎可用于传输数据，而3D引擎可用于3D渲染。虽然3D引擎也可用于移动数据，但可以将简单的数据传输卸载到复制引擎，从而使3D引擎能够处理更复杂的任务，从而提高整体性能。在这种情况下，复制引擎和3D引擎将并行运行。</p><blockquote style=\"text-align: justify;\"><p>A GPU engine represents an independent unit of silicon on the GPU that can be scheduled and can operate in parallel with one another. For example, a copy engine may be used to transfer data around while a 3D engine is used for 3D rendering. While the 3D engine can also be used to move data around, simple data transfers can be offloaded to the copy engine, allowing the 3D engine to work on more complex tasks, improving overall performance. In this case both the copy engine and the 3D engine would operate in parallel.</p></blockquote><p style=\"text-align: justify;\">VidSch负责在想要使用它们的各种进程中对这些GPU引擎中的每一个进行仲裁、优先级排序和调度。</p><blockquote style=\"text-align: justify;\"><p>VidSch is responsible for arbitrating, prioritizing and scheduling each of these GPU engines across the various processes wanting to use them.</p></blockquote><p style=\"text-align: justify;\">将GPU引擎与GPU核心区分开来很重要。GPU引擎由GPU内核组成。例如，3D引擎可能有1000多个核心，但这些核心在一个称为引擎的实体中组合在一起，并被安排为一个组。当一个进程获得一个引擎的时间片时，它就可以使用该引擎的所有底层核心。</p><blockquote style=\"text-align: justify;\"><p>It’s important to distinguish GPU engines from GPU cores. GPU engines are made up of GPU cores. The 3D engine, for instance, might have 1000s of cores, but these cores are grouped together in an entity called an engine and are scheduled as a group. When a process gets a time slice of an engine, it gets to use all of that engine’s underlying cores.</p></blockquote><p style=\"text-align: justify;\">一些GPU支持多个引擎映射到相同的底层核心集。虽然这些引擎也可以并行调度，但它们最终会共享底层内核。这在概念上类似于CPU上的超线程。例如，3D引擎和Compute引擎实际上可能依赖于同一组统一内核。在这种情况下，内核在执行时在引擎之间进行空间或时间分区。</p><blockquote style=\"text-align: justify;\"><p>Some GPUs support multiple engines mapping to the same underlying set of cores. While these engines can also be scheduled in parallel, they end up sharing the underlying cores. This is conceptually similar to hyper-threading on the CPU. For example, a 3D engine and a compute engine may in fact be relying on the same set of unified cores. In such a scenario, the cores are either spatially or temporally partitioned between engines when executing.</p></blockquote><p style=\"text-align: justify;\">下图展现了假象的GPU引擎和内核。</p><blockquote style=\"text-align: justify;\"><p>The figure below illustrates engines and cores of a hypothetical GPU.</p></blockquote><p style=\"text-align: justify;\"><img src=\"https://raw.githubusercontent.com/Direct5dom/imageDB/main/202205081144808.png\" alt=\"\"></p><p style=\"text-align: justify;\">默认情况下，任务管理器会选择4个引擎来显示。任务管理器将选择它认为最有趣的引擎。您可以通过单击引擎名称并从GPU公开的引擎列表中选择另一个引擎来决定要观察哪个引擎。</p><blockquote style=\"text-align: justify;\"><p>By default, the Task Manager will pick 4 engines to be displayed. The Task Manager will pick the engines it thinks are the most interesting. However, you can decide which engine you want to observe by clicking on the engine name and choosing another one from the list of engines exposed by the GPU.</p></blockquote><p style=\"text-align: justify;\">引擎的数量和这些引擎的使用在GPU之间会有所不同。GPU驱动程序可能决定使用Video Decode引擎对特定媒体剪辑进行解码，而使用不同视频格式的另一个剪辑可能依赖于Compute引擎，甚至是多个引擎的组合。使用新的任务管理器，您可以在GPU上运行工作负载，然后观察哪些引擎可以处理它。</p><blockquote style=\"text-align: justify;\"><p>The number of engines and the use of these engines will vary between GPUs. A GPU driver may decide to decode a particular media clip using the video decode engine while another clip, using a different video format, might rely on the compute engine or even a combination of multiple engines. Using the new Task Manager, you can run a workload on the GPU then observe which engines gets to process it.</p></blockquote><p style=\"text-align: justify;\">在GPU名称下的左窗格和右窗格的底部，您会注意到GPU的汇总利用率百分比。在这里，我们有几个不同的选择来汇总跨引擎的利用率。跨引擎的平均利用率可能会让人有所误解，因为具有10个引擎的GPU（例如，运行一个完全饱和3D引擎的游戏）会聚合到10%的总体利用率！ 这绝对不是游戏玩家想要看到的。我们也可以选择3D引擎来代表整个GPU，因为它通常是最突出和最常用的引擎，但这也可能误导用户。例如，在某些情况下播放视频可能根本不使用3D引擎，在这种情况下，在播放视频时GPU上的聚合利用率会报告为0%！ 相反，我们选择选择最繁忙引擎的百分比利用率作为整体GPU使用率的代表。</p><blockquote style=\"text-align: justify;\"><p>In the left pane under the GPU name and at the bottom of the right pane, you’ll notice an aggregated utilization percentage for the GPU. Here we had a few different choices on how we could aggregate utilization across engines. The average utilization across engines felt misleading since a GPU with 10 engines, for example, running a game fully saturating the 3D engine, would have aggregated to a 10% overall utilization! This is definitely not what gamers want to see. We could also have picked the 3D Engine to represent the GPU as a whole since it is typically the most prominent and used engine, but this could also have misled users. For example, playing a video under some circumstances may not use the 3D engine at all in which case the aggregated utilization on the GPU would have been reported as 0% while the video is playing! Instead we opted to pick the percentage utilization of the busiest engine as a representative of the overall GPU usage.</p></blockquote><h4 id=\"显存（Video-Memory）\" style=\"text-align: justify;\">显存（Video Memory）</h4><p style=\"text-align: justify;\">引擎图表下方是显存利用率图表和摘要。显存分为两大类：专用和共享。</p><blockquote style=\"text-align: justify;\"><p>Below the engines graphs are the video memory utilization graphs and summary. Video memory is broken into two big categories: dedicated and shared.</p></blockquote><p style=\"text-align: justify;\">专用内存表示专门保留供GPU使用并由VidMm管理的内存。在独立显卡上，这就是您的VRAM，即位于显卡上的内存。在集成显卡上，这是为图形保留的系统内存量。许多集成显卡避免为专有图形使用保留内存，而是选择完全依赖与CPU共享的内存，这样效率更高。</p><blockquote style=\"text-align: justify;\"><p>Dedicated memory represents memory that is exclusively reserved for use by the GPU and is managed by VidMm. On discrete GPUs this is your VRAM, the memory that sits on your graphics card. Â Â On integrated GPUs, this is the amount of system memory that is reserved for graphics. Many integrated GPU avoid reserving memory for exclusive graphics use and instead opt to rely purely on memory shared with the CPU which is more efficient.</p></blockquote><p style=\"text-align: justify;\">这少量的驱动程序保留内存由硬件保留内存表示。</p><blockquote style=\"text-align: justify;\"><p>This small amount of driver reserved memory is represented by the Hardware Reserved Memory.</p></blockquote><p style=\"text-align: justify;\">对于集成显卡，情况更为复杂。一些集成显卡具有专用内存，而另一些则没有。一些集成GPU在固件中（或在驱动程序初始化期间）从主DRAM中保留内存。尽管此内存是从与CPU共享的DRAM中分配的，但它是从Windows中取出的，并且不受Windows内存管理器 (Mm) 的控制，并由VidMm专门管理。这种类型的保留通常不鼓励使用更灵活的共享内存，但某些GPU当前需要它。</p><blockquote style=\"text-align: justify;\"><p>For integrated GPUs, it’s more complicated. Some integrated GPUs will have dedicated memory while others won’t. Some integrated GPUs reserve memory in the firmware (or during driver initialization) from main DRAM. Although this memory is allocated from DRAM shared with the CPU, it is taken away from Windows and out of the control of the Windows memory manager (Mm) and managed exclusively by VidMm. This type of reservation is typically discouraged in favor of shared memory which is more flexible, but some GPUs currently need it.</p></blockquote><p style=\"text-align: justify;\">性能选项卡下的专用内存量表示当前所有进程消耗的字节数，这与许多显示进程请求的内存的现有实用程序不同。</p><blockquote style=\"text-align: justify;\"><p>The amount of dedicated memory under the performance tab represents the number of bytes currently consumed across all processes, unlike many existing utilities which show the memory requested by a process.</p></blockquote><p style=\"text-align: justify;\">共享内存表示可由GPU或CPU使用的普通系统内存。这种内存很灵活，可以以任何一种方式使用，甚至可以根据用户工作负载的需要来回切换。独立和集成显卡都可以使用共享内存。</p><blockquote style=\"text-align: justify;\"><p>Shared memory represents normal system memory that can be used by either the GPU or the CPU. This memory is flexible and can be used in either way, and can even switch back and forth as needed by the user workload. Both discrete and integrated GPUs can make use of shared memory.</p></blockquote><p style=\"text-align: justify;\">Windows有一个策略，即GPU在任何给定时刻只允许使用一半的物理内存。这是为了确保系统的其余部分有足够的内存继续正常运行。在16GB系统上，GPU可以随时使用多达8GB的DRAM。应用程序可以分配比这更多的显存。事实上，显存在Windows上是完全虚拟化的，仅受系统提交总限制（即安装的DRAM总量 + 磁盘上页面文件的大小）的限制。VidMm将通过动态锁定和释放DRAM页面来确保GPU不会超过其一半的DRAM预算。同样，当表面不使用时，VidMm会随着时间的推移将内存页面释放回Mm，以便在必要时可以重新调整它们的用途。性能选项卡下消耗的共享内存量本质上表示GPU当前消耗的此类共享系统内存量与此限制相比。</p><blockquote style=\"text-align: justify;\"><p>Windows has a policy whereby the GPU is only allowed to use half of physical memory at any given instant. This is to ensure that the rest of the system has enough memory to continue operating properly. On a 16GB system the GPU is allowed to use up to 8GB of that DRAM at any instant. It is possible for applications to allocate much more video memory than this. Â As a matter of fact, video memory is fully virtualized on Windows and is only limited by the total system commit limit (i.e. total DRAM installed + size of the page file on disk). VidMm will ensure that the GPU doesn’t go over its half of DRAM budget by locking and releasing DRAM pages dynamically. Similarly, when surfaces aren’t in use, VidMm will release memory pages back to Mm over time, such that they may be repurposed if necessary. The amount of shared memory consumed under the performance tab essentially represents the amount of such shared system memory the GPU is currently consuming against this limit.</p></blockquote><h3 id=\"进程选项卡（Processes-Tab）\" style=\"text-align: justify;\">进程选项卡（Processes Tab）</h3><p style=\"text-align: justify;\">在进程选项卡下，您会找到按进程细分的GPU利用率汇总摘要。</p><blockquote style=\"text-align: justify;\"><p>Under the process tab you’ll find an aggregated summary of GPU utilization broken down by processes.</p></blockquote><p style=\"text-align: justify;\"><img src=\"https://raw.githubusercontent.com/Direct5dom/imageDB/main/202205081145721.png\" alt=\"\"></p><p style=\"text-align: justify;\">值得讨论一下聚合在这个视图中是如何工作的。正如我们之前看到的，一台PC可以有多个GPU，每个GPU通常都有多个引擎。为每个GPU和引擎组合添加一个列会导致典型PC上出现数十个新列，从而使视图变得笨拙。性能选项卡旨在让用户快速简单地了解其系统资源在各种运行进程中的使用情况，因此我们希望保持其简洁明了，同时仍提供有关GPU的有用信息。</p><blockquote style=\"text-align: justify;\"><p>It’s worth discussing how the aggregation works in this view. As we’ve seen previously, a PC can have multiple GPUs and each of these GPU will typically have several engines. Adding a column for each GPU and engine combinations would leads to dozens of new columns on typical PC making the view unwieldy. The performance tab is meant to give a user a quick and simple glance at how his system resources are being utilized across the various running processes so we wanted to keep it clean and simple, while still providing useful information about the GPU.</p></blockquote><p style=\"text-align: justify;\">我们决定采用的解决方案是显示所有GPU中最繁忙引擎的利用率，以表示该进程的整体GPU利用率。但如果这就是我们所做的一切，事情仍然会令人困惑。一个应用程序可能使3D引擎饱和100%，而另一个应用程序使视频引擎饱和100%。在这种情况下，两个应用程序都报告了 100% 的总体利用率，这会令人困惑。为了解决这个问题，我们添加了第二列，它指示所显示的利用率对应于哪个 GPU 和引擎组合。我们想听听您对这种设计选择的看法。</p><blockquote style=\"text-align: justify;\"><p>The solution we decided to go with is to display the utilization of the busiest engine, across all GPUs, for that process as representing its overall GPU utilization. But if that’s all we did, things would still have been confusing. One application might be saturating the 3D engine at 100% while another saturates the video engine at 100%. In this case, both applications would have reported an overall utilization of 100%, which would have been confusing. To address this problem, we added a second column, which indicates which GPU and Engine combination the utilization being shown corresponds to. We would like to hear what you think about this design choice.</p></blockquote><p style=\"text-align: justify;\">同样，列顶部的利用率摘要是所有GPU的利用率最大值。此处的计算与性能选项卡下显示的整体GPU利用率相同。</p><blockquote style=\"text-align: justify;\"><p>Similarly, the utilization summary at the top of the column is the maximum of the utilization across all GPUs. The calculation here is the same as the overall GPU utilization displayed under the performance tab.</p></blockquote><h3 id=\"详细信息选项卡（Details-Tab）\" style=\"text-align: justify;\">详细信息选项卡（Details Tab）</h3><p style=\"text-align: justify;\">默认情况下，详细信息选项卡下没有关于GPU的信息。但是您可以右键单击列标题，选择“选择列”，然后添加GPU利用率计数器（与上述相同）或显存使用计数器。</p><blockquote style=\"text-align: justify;\"><p>Under the details tab there is no information about the GPU by default. But you can right-click on the column header, choose “Select columns”, and add either GPU utilization counters (the same one as described above) or video memory usage counters.</p></blockquote><p style=\"text-align: justify;\"><img src=\"https://raw.githubusercontent.com/Direct5dom/imageDB/main/202205081145252.png\" alt=\"\"></p><p style=\"text-align: justify;\">关于这些显存使用计数器，有几点需要注意。计数器表示该进程当前使用的专用和共享显存的总量。这包括私有内存（即由该进程专门使用的内存）以及跨进程共享内存（即与其他进程共享的内存，不要与CPU和GPU之间共享的内存混淆）。</p><blockquote style=\"text-align: justify;\"><p>There are a few things that are important to note about these video memory usage counters. The counters represent the total amount of dedicated and shared video memory currently in used by that process. This includes both private memory (i.e. memory that is used exclusively by that process) as well as cross-process shared memory (i.e. memory that is shared with other processes not to be confused with memory shared between the CPU and the GPU).</p></blockquote><p style=\"text-align: justify;\">因此，添加每个单独进程使用的内存总和将超过GPU使用的内存量，因为跨进程共享的内存将被多次计算。每个进程的细分有助于了解特定进程当前使用了多少显存，但要了解GPU使用了多少总内存，应该在性能选项卡下查看适当考虑共享内存的总和。</p><blockquote style=\"text-align: justify;\"><p>As a result of this, adding the memory utilized by each individual process will sum up to an amount of memory larger than that utilized by the GPU since memory shared across processes will be counted multiple times. The per process breakdown is useful to understand how much video memory a particular process is currently using, but to understand how much overall memory is used by a GPU, one should look under the performance tab for a summation that properly takes into account shared memory.</p></blockquote><p style=\"text-align: justify;\">另一个有趣的结果是，一些与其他进程共享大量内存的系统进程，特别是dwm.exe和csrss.exe，看起来会比实际大得多。例如，当应用程序创建一个顶级窗口时，将分配显存来保存该窗口的内容。该显存表面由csrss.exe代表应用程序创建，可能映射到应用程序进程本身并与桌面窗口管理器 (dwm.exe) 共享，以便可以将窗口组合到桌面上。显存只分配一次，但可能从所有三个进程都可以访问，并且显示在它们各自的内存利用率上。同样，应用程序DirectX交换链或DCOMP视觉 (XAML) 与桌面合成器共享。这两个进程出现的大部分显存实际上是应用程序创建与它们共享的东西的结果，因为它们自己分配的很少。这也是为什么您会看到这些随着您的桌面变得忙碌而增长的原因，但请记住，它们并没有真正消耗您的所有资源。</p><blockquote style=\"text-align: justify;\"><p>Another interesting consequence of this is that some system processes, in particular dwm.exe and csrss.exe, that share a lot of memory with other processes will appear much larger than they really are. For example, when an application creates a top level window, video memory will be allocated to hold the content of that window. That video memory surface is created by csrss.exe on behalf of the application, possibly mapped into the application process itself and shared with the desktop window manager (dwm.exe) such that the window can be composed onto the desktop. The video memory is allocated only once but is accessible from possibly all three processes and appears against their individual memory utilization. Similarly, application DirectX swapchain or DCOMP visual (XAML) are shared with the desktop compositor. Most of the video memory appearing against these two processes is really the result of an application creating something that is shared with them as they by themselves allocate very little. This is also why you will see these grow as your desktop gets busy, but keep in mind that they aren’t really consuming up all of your resources.</p></blockquote><p style=\"text-align: justify;\">我们本可以决定显示每个进程的私有内存故障并忽略共享内存。但是，这会使许多应用程序看起来比实际小得多，因为我们在Windows中大量使用了共享内存。特别是，对于通用应用程序，应用程序通常具有与桌面合成器完全共享的复杂可视树，因为这允许合成器仅在需要时呈现应用程序的更智能和更有效的方式，并导致整体更好的性能 系统。我们不认为隐藏共享内存是正确的答案。我们也可以选择为常规进程显示私有+共享，但只对csrss.exe和dwm.exe显示私有，但这也感觉像是对高级用户隐藏有用的信息。</p><blockquote style=\"text-align: justify;\"><p>We could have decided to show a per process private memory breakdown instead and ignore shared memory. However, this would have made many applications looks much smaller than they really are since we make significant use of shared memory in Windows. In particular, with universal applications it’s typical for an application to have a complex visual tree that is entirely shared with the desktop compositor as this allows the compositor a smarter and more efficient way of rendering the application only when needed and results in overall better performance for the system. We didn’t think that hiding shared memory was the right answer. We could also have opted to show private+shared for regular processes but only private for csrss.exe and dwm.exe, but that also felt like hiding useful information to power users.</p></blockquote><p style=\"text-align: justify;\">这种增加的复杂性是我们不在默认视图中显示此信息并将其保留给知道如何找到它的高级用户的原因之一。最后，我们决定采用透明度，并采用包括私有和跨进程共享内存的细分。这是我们对反馈特别感兴趣的领域，并期待听到您的想法。</p><blockquote style=\"text-align: justify;\"><p>This added complexity is one of the reason we don’t display this information in the default view and reserve this for power users who will know how to find it. In the end, we decided to go with transparency and went with a breakdown that includes both private and cross-process shared memory. This is an area we’re particularly interested in feedback and are looking forward to hearing your thoughts.</p></blockquote><h3 id=\"结语（Closing-thought）\" style=\"text-align: justify;\">结语（Closing thought）</h3><p style=\"text-align: justify;\">我们希望您发现此信息很有用，并将帮助您充分利用新的任务管理器 GPU 性能数据。</p><blockquote style=\"text-align: justify;\"><p>We hope you found this information useful and that it will help you get the most out of the new Task Manager GPU performance data.</p></blockquote><p style=\"text-align: justify;\">请放心，这项工作背后的团队将密切关注您的建设性反馈和建议，让他们不断涌现！ 提供反馈的最佳方式是通过反馈中心。要启动反馈中心，请使用我们的键盘快捷键 Windows 键 + f。在&nbsp;<em>Desktop Environment -&gt; Task Manager.</em>&nbsp;类别下提交您的反馈（并向我们发送赞成票）</p><blockquote style=\"text-align: justify;\"><p>Rest assured that the team behind this work will be closely monitoring your constructive feedback and suggestions so keep them coming! The best way to provide feedback is through the Feedback Hub. To launch the Feedback Hub use our keyboard shortcut Windows key + f. Submit your feedback (and send us upvotes) under the category&nbsp;<em>Desktop Environment -&gt; Task Manager.</em></p></blockquote>','2022-06-02 01:50:24','2022-06-02 01:50:24','原文链接：GPUs in the task manager - DirectX Developer Blog (microsoft.com)Bryan L 发布于 2017 年 7 月 21 日下面的帖子来自Steve Pronovost，他是我们负责GPU调度和内存管理的首席工程师。The bel','/img/thumbnail/random/img_5.jpg',1),(62,1,'Drawbridge Overview（Drawbridge概述）','<p><footer class=\"post-footer\" style=\"text-align: start;\"></footer></p><div class=\"post-body\" itemprop=\"articleBody\" style=\"text-align: justify;\"><p>翻译自用，原文链接：<a target=\"_blank\" rel=\"noopener\" href=\"https://www.microsoft.com/en-us/research/project/drawbridge/?from=https%3A%2F%2Fresearch.microsoft.com%2Fen-us%2Fprojects%2Fdrawbridge%2F#!overview\" data-pjax-state=\"\">Drawbridge - Microsoft Research</a></p><p>Presentations：<a target=\"_blank\" rel=\"noopener\" href=\"https://channel9.msdn.com//shows//going+Deep//drawbridge-An-Experimental-Library-Operating-System\" data-pjax-state=\"\">Drawbridge: A new form of virtualization for application sandboxing | Going Deep | Channel 9 (msdn.com)</a></p><span id=\"more\"></span><p>Drawbridge 是一种新型应用程序沙盒虚拟化的研究原型。 Drawbridge 结合了两项核心技术：首先是 picoprocess，它是一个基于进程的隔离容器，具有最少的内核外部 API (API surface)。 其次是一个library OS<a href=\"https://direct5dom.github.io/2021/09/07/Drawbridge-Overview%EF%BC%88Drawbridge%E6%A6%82%E8%BF%B0%EF%BC%89/%E4%B8%80%E7%A7%8D%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F%E6%9E%B6%E6%9E%84\" data-pjax-state=\"\">^1</a>，它是 Windows 的一个版本，可以在 picoprocess 中高效运行。</p><blockquote><p>Drawbridge is a research prototype of a new form of virtualization for application sandboxing. Drawbridge combines two core technologies: First, a picoprocess, which is a process-based isolation container with a minimal kernel API surface. Second, a library OS, which is a version of Windows enlightened to run efficiently within a picoprocess.</p></blockquote><p>A Windows Library OS in context：</p><p><img src=\"https://www.microsoft.com/en-us/research/uploads/prod/2016/02/drawbridge-library_os.png\" alt=\"Library OS\"></p><p>基于硬件的虚拟机 (VM) 从根本上改变了数据中心的计算并启发出了云技术。 虚拟机提供三个引人注目的特性：</p><blockquote><p>Hardware-based Virtual Machines (VMs) have fundamentally changed computing in data centers and enabled the cloud. VMs offer three compelling qualities:</p></blockquote><ol><li><strong>安全隔离</strong>：隔离应用程序，使行为不端 (恶意) 的应用程序无法危及其他应用程序或其主机。</li><li><strong>持久兼容性</strong>：允许主机和应用程序分开发展。 主机中的更改不会破坏应用程序。</li><li><strong>执行连续性</strong>：允许应用程序摆脱与特定主机的联系。 正在运行的应用程序不依赖于所启动它的计算机，但可以在一次运行中跨空间和时间进行计算机间的转移。</li></ol><blockquote><ol><li><strong>Secure Isolation</strong>: isolating applications so that an ill-behaved application can’t compromise other applications or its host.</li><li><strong>Persistent Compatibility</strong>: allowing host and application to evolve separately. Changes in the host don’t break applications.</li><li><strong>Execution Continuity</strong>: allowing applications to be freed of ties to a specific host computer. A running application isn’t tied to the computer on which it was started, but can be moved from computer to computer across space and time within a single run.</li></ol></blockquote><p>尽管有这些优势，但虚拟机在磁盘占用空间、内存、CPU 和管理成本方面存在大量资源开销。</p><blockquote><p>Despite these advantages, VMs have large resource overheads in terms of disk footprint, memory, CPU, and administrative costs.</p></blockquote><p>Drawbridge 结合了文献中的两个想法，picoprocess 和 library OS 提供了一种新的计算形式，它保留了安全隔离、持久兼容性和执行连续性的优点，但资源开销大大降低。</p><blockquote><p>Drawbridge combines two ideas from the literature, the<span>&nbsp;</span><em>picoprocess</em><span>&nbsp;</span>and the<span>&nbsp;</span><em>library OS</em>, to provide a new form of computing, which retains the benefits of secure isolation, persistent compatibility, and execution continuity, but with drastically lower resource overheads.</p></blockquote><p>虽然仍是一项实验，但 Drawbridge 无需修改即可运行许多现有的 Windows 应用程序，从 Microsoft Office 2010 和 Internet Explorer 等桌面应用程序到 IIS 等服务器应用程序。</p><blockquote><p>While still an experiment, Drawbridge runs many existing Windows applications without modifications ranging from desktop applications like Microsoft Office 2010 and Internet Explorer to server applications like IIS.</p></blockquote><h2 id=\"The-Picoprocess\">The Picoprocess</h2><p>The Picopress isolation container：</p><p><img src=\"https://www.microsoft.com/en-us/research/uploads/prod/2016/02/drawbridge-picoprocess_small.png\" alt=\"Picoprocess\"></p><p>Drawbridge picoprocess 是一个轻量级、安全的隔离容器。 它是从操作系统进程地址空间构建的，但删除了所有传统的操作系统服务。 在 picoprocess 中运行的代码和操作系统之间的应用程序二进制接口[^2]遵循硬件 VM 的设计模式； 它由一组封闭的 45 个下行调用组成，具有固定语义，提供无状态接口。 所有 ABI 调用都由安全监视器提供服务，其作用类似于传统硬件 VM 设计中的管理程序或 VM 监视器。</p><blockquote><p>The Drawbridge picoprocess is a lightweight, secure isolation container. It is built from an OS process address space, but with all traditional OS services removed. The application binary interface (ABI) between code running in the picoprocess and the OS follows the design patterns of hardware VMs; it consists of a closed set of 45 downcalls with fixed semantics that provide a stateless interface. All ABI calls are serviced by the security monitor, which plays a role similar to the hypervisor or VM monitor in traditional hardware VM designs.</p></blockquote><p>虽然 Drawbridge picoprocess 接口遵循硬件 VM 接口的设计模式，但它高度抽象。 Drawbridge picoprocess 接口显示线程、私有虚拟内存和 I/O 流，而不是像 CPU、MMU 和设备寄存器这样的低级硬件抽象。 这些更高级别的抽象允许更有效地实现托管在 picoprocess 中的 OS 代码。 这些更高级别的抽象还允许更有效地利用资源。</p><blockquote><p>While the Drawbridge picoprocess interface follows the design patterns of hardware VM interfaces, it uses a high level of abstraction. The Drawbridge picoprocess interface surfaces threads, private virtual memory, and I/O streams instead of low-level hardware abstractions like CPUs, MMUs, and device registers. These higher-level abstractions allow for much more efficient implementations of OS code hosted within the picoprocess. These higher-level abstractions also allow for much more efficient resource utilization.</p></blockquote><h2 id=\"The-Library-OS\">The Library OS</h2><p>更好的沙箱容器是虚拟化应用程序更大可扩展性的必要不充分条件。 第二个关键要素是 library OS 。 library OS 是经过重构的操作系统，可作为应用程序上下文中的一组库运行。</p><blockquote><p>A better sandbox container is a necessary, but not sufficient condition for greater scalability of virtualized applications. The key second ingredient is the library OS. A library OS is an operating system refactored to run as a set of libraries within the context of an application.</p></blockquote><p>虽然 Drawbridge 可以运行许多可能的 library OS ，但 Drawbridge 的一个关键的贡献是一个 Windows 版本。启发了这个版本的 Windows 在单个 Drawbridge picoprocess 中运行的方式。 Drawbridge Windows library OS 由用户态 NT 内核（非正式地称为 NTUM）组成，它在 picoprocess 中运行。 NTUM 提供与在裸机硬件和硬件 VM 上运行的传统 NT 内核相同的 NT API，但由于它使用 Drawbridge ABI 公开的更高级别的抽象，因此要小得多。 除了 NTUM 之外，Drawbridge 还包含一个 Win32 子系统版本，该子系统在 picoprocess 中作为用户态库运行。</p><blockquote><p>While Drawbridge can run many possible library OSes, a key contribution of Drawbridge is a version of Windows that has been enlightened to run within a single Drawbridge picoprocess. The Drawbridge Windows library OS consists of a user-mode NT kernel–informally referred to as NTUM–which runs within the picoprocess. NTUM provides the same NT API as the traditional NT kernel that runs on bare hardware and in hardware VMs, but is much smaller as it uses the higher-level abstractions exposed by the Drawbridge ABI. In addition to NTUM, Drawbridge includes a version of the Win32 subsystem that runs as a user-mode library within the picoprocess.</p></blockquote><p>基于 NTUM 的基本服务和用户态 Win32 子系统，Drawbridge 可以运行来自基于硬件的 Windows 版本的许多 DLL 和服务。 因此，Drawbridge 原型可以运行大量的 Windows 桌面和服务器应用程序，而无需修改这些应用程序。</p><blockquote><p>Upon the base services of NTUM and the user-mode Win32 subsystem, Drawbridge can run many of the DLLs and services from the hardware-based versions of Windows. As a result, the Drawbridge prototype can run large classes of Windows desktop and server applications with no modifications to the applications.</p></blockquote><h2 id=\"Presentations\">Presentations</h2><ul><li>[<a target=\"_blank\" rel=\"noopener\" href=\"http://channel9.msdn.com//shows//going+Deep//drawbridge-An-Experimental-Library-Operating-System\" data-pjax-state=\"\">Drawbridge: A New Form of Virtualization for Application Sandboxing</a>](<a target=\"_blank\" rel=\"noopener\" href=\"https://channel9.msdn.com//shows//going+Deep//drawbridge-An-Experimental-Library-Operating-System\" data-pjax-state=\"\">https://channel9.msdn.com//shows//going+Deep//drawbridge-An-Experimental-Library-Operating-System</a>),<span>&nbsp;</span><a target=\"_blank\" rel=\"noopener\" href=\"https://channel9.msdn.com/\" data-pjax-state=\"\">Channel 9</a>video and blog, Redmond, WA, March, 2011.</li></ul><h2 id=\"注释\">注释</h2><p>[^2]: Application Binary Interface (ABI)</p></div>','2022-06-02 01:51:37','2022-06-02 01:51:37','翻译自用，原文链接：Drawbridge - Microsoft ResearchPresentations：Drawbridge: A new form of virtualization for application sandboxing | Going Deep | Channel 9 (m','/img/thumbnail/random/img_5.jpg',1),(63,1,'Inside NAND Flash Memories读书笔记01','<h2 id=\"半导体存储器的种类\" style=\"text-align: justify;\">半导体存储器的种类</h2><p style=\"text-align: justify;\">半导体存储器可以简单的分为两个大类：</p><ul style=\"text-align: justify;\"><li><span>RAM</span>—— Random Access Memory。即：随机访问存储器。它可以自由存取内容，但在断电后数据会消失。</li><li><span>ROM</span>——Read Only Memory。即：只读存储器。它的数据无法修改，但在断电后数据不会消失。</li></ul><p style=\"text-align: justify;\">而在介于这两者之间存在一个中间分类：</p><ul style=\"text-align: justify;\"><li><span>NVM</span>——Non-Volatile Memories。即：非易失性存储器。它既可以自由存取内容，也不会在断电后数据消失。</li></ul><p style=\"text-align: justify;\">NVM的历史开始于20世纪70年代，随着第一个EPROM存储器 (可擦除可编程的只读存储器) 的推出，NVM就一直被认为是最重要的半导体产品之一。</p><h2 id=\"闪存的存储单元-Cell\" style=\"text-align: justify;\">闪存的存储单元 (Cell)</h2><p style=\"text-align: justify;\">现在大多数闪存的Cell都是基于浮栅 (Floating Gate, FG) 技术，其结构如下所示：</p><p><img src=\"https://raw.githubusercontent.com/Direct5dom/imageDB/main/img/202205252013742.png\" style=\"text-align: justify;\"></p><p style=\"text-align: justify;\">该结构在原MOS管的控制栅极 (CG) 上增加了一层浮栅 (FG) 。该浮栅 (FG) 被氧化层完全包围，构成了一个极好的电子“陷阱”，可以起到捕获电子并长时间储存的作用。</p><p style=\"text-align: justify;\">从浮栅层注入和擦除电子的操作分别被命名为<span>Program (编程)<span>和</span>Erase (擦除)</span>，这两个操作改变了Cell内部的<span>阈值电压V_TH</span>。当对Cell施加一个固定的电压时，因为V_TH的大小不同，就可以区分出不同的状态，例如：当施加的电压高于单元的V_TH时，Cell就被识别为<code>1</code>，反之为<code>0</code>。</p><h2 id=\"NAND闪存\" style=\"text-align: justify;\">NAND闪存</h2><h3 id=\"NAND存储器阵列\" style=\"text-align: justify;\">NAND存储器阵列</h3><p style=\"text-align: justify;\">在闪存芯片中，Cell被包装成一个阵列，以优化硅片面积的占用。</p><p style=\"text-align: justify;\">根据Cell在阵列中的组织方式，分为了NAND和NOR闪存。这里我们主要看NAND闪存的架构：</p><p><img src=\"https://raw.githubusercontent.com/Direct5dom/imageDB/main/img/202205291016685.png\" style=\"text-align: justify;\"></p><p style=\"text-align: justify;\">在NAND串 (NAND string) 中，Cell以32或64个为一组被串联起来，两端通过两个选择晶体管M_SL和M_DL连接到Source Line (SL)和Bitline (BL)。</p><p style=\"text-align: justify;\">每个NAND串与另一个NAND串共享Bitline，控制栅极 (CG) 通过Wordline (WL) 连接。</p><p style=\"text-align: justify;\"><span>同属一个WL的Cell组成一个Page</span>，例如：<code>WL_0&lt;0&gt;</code>。</p><blockquote style=\"text-align: justify;\"><p>每条WL的Page数量和Cell的存储能力有关，根据存储层数的不同，闪存也有不同的称呼：</p><ul><li>SLC——Single-Level Cell，每单元存储1bit。</li><li>MLC——Multi-Level Cell，每单元存储2bit。</li><li>TLC——Triple-Level Cell，每单元存储3bit。</li><li>QLC——Quad-Level Cell，每单元存储5bit。</li></ul><img src=\"https://github.com/Direct5dom/imageDB/blob/main/img/202205291005443.png?raw=true\" alt=\"202205291005443.png\"></blockquote><p style=\"text-align: justify;\">对于一个具有奇偶BL的SLC来说 (如上图右边的结构) ，偶数和奇数的Cell们会组成两个不同的页面。例如，一个4kB的页面的SLC有一个65536个Cell的WL，即在原本的基础上翻两倍。</p><blockquote style=\"text-align: justify;\"><p>当然，对于MLC来说，奇偶BL会有四个页面，因为每个Cell存储一个最小有效位 (LSB) 和最大有效位 (MSB) ，因此就有：</p><ul><li>偶数BL上的MSB和LSB；</li><li>奇数BL上的MSB和LSB。</li></ul></blockquote><p style=\"text-align: justify;\"><span>共享同一组WL的NAND串组成一个Block</span>，例如：<code>WL_0&lt;0:63&gt;</code>。</p><blockquote style=\"text-align: justify;\"><p>在执行Erase擦除操作时，所有共享同一组WL的NAND串会被一起擦除，因此Erase操作的最小单位是Block。</p></blockquote><p style=\"text-align: justify;\">NAND闪存主要由存储阵列组成。因此，为进行Read、Program、Erase操作，还需要额外的电路。由于NAND芯片最重要被封入到一个有明确尺寸的封装中，因此在早期设计阶段组织布局所有的电路和阵列是很重要的。一个简单的平面图如下：</p><p><img src=\"https://raw.githubusercontent.com/Direct5dom/imageDB/main/img/202205291102180.png\" style=\"text-align: justify;\"></p><p style=\"text-align: justify;\">在上图中，存储阵列 (Memory Array) 被分割成不同的<span>Plane</span>。水平方向是Wordline的方向，垂直方向是Bitline的方向。</p><p style=\"text-align: justify;\">一个**行解码器 (Row Decoder)**位于两个Plane之间，该电路的任务是对选定的NAND串的所有WL进行适当的偏移。</p><p style=\"text-align: justify;\">所有的BL都连接到<span>感应放大器 (Sense Amp)</span>，每个感应放大器可以有一条或多条BL，感应放大器的任务是将存储单元的电流转换为数字值。</p><p style=\"text-align: justify;\">在外围区域，有<span>电荷泵 (Charge Pumps)</span>、<span>稳压器 (Voltage Regulators)</span>、<span>逻辑电路 (Logic Circuits)<span>和</span>冗余结构 (Redundancy Structures)</span>。PDA焊盘用于与外部进行通信。</p>','2022-06-02 01:57:29','2022-06-02 01:57:29','半导体存储器的种类半导体存储器可以简单的分为两个大类：RAM—— Random Access Memory。即：随机访问存储器。它可以自由存取内容，但在断电后数据会消失。ROM——Read Only Memory。即：只读存储器。它的数据无法修改，但在断电后数据不会消失。而在介于这两者之间存在一个中','/img/thumbnail/random/img_5.jpg',1);
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_category_ref`
--

DROP TABLE IF EXISTS `article_category_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_category_ref` (
  `article_id` int NOT NULL COMMENT '文章ID',
  `category_id` int NOT NULL COMMENT '分类ID',
  PRIMARY KEY (`article_id`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_category_ref`
--

LOCK TABLES `article_category_ref` WRITE;
/*!40000 ALTER TABLE `article_category_ref` DISABLE KEYS */;
INSERT INTO `article_category_ref` VALUES (61,100000013),(62,100000014),(63,100000015);
/*!40000 ALTER TABLE `article_category_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_tag_ref`
--

DROP TABLE IF EXISTS `article_tag_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_tag_ref` (
  `article_id` int NOT NULL COMMENT '文章ID',
  `tag_id` int NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`article_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_tag_ref`
--

LOCK TABLES `article_tag_ref` WRITE;
/*!40000 ALTER TABLE `article_tag_ref` DISABLE KEYS */;
INSERT INTO `article_tag_ref` VALUES (61,43),(61,44),(61,45),(62,46),(63,47),(63,48);
/*!40000 ALTER TABLE `article_tag_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `category_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_name` varchar(50) DEFAULT NULL COMMENT '分类名',
  `category_icon` varchar(20) DEFAULT NULL COMMENT '图标',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=100000016 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (100000013,'DirectX',''),(100000014,'WSL',''),(100000015,'Inside NAND Flash Memories读书笔记','');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `link`
--

DROP TABLE IF EXISTS `link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `link` (
  `link_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '链接ID',
  `link_url` varchar(255) DEFAULT NULL COMMENT 'URL',
  `link_name` varchar(255) DEFAULT NULL COMMENT '连接名',
  `link_update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `link_create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `link_status` int unsigned DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`link_id`),
  UNIQUE KEY `link_name` (`link_name`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `link`
--

LOCK TABLES `link` WRITE;
/*!40000 ALTER TABLE `link` DISABLE KEYS */;
INSERT INTO `link` VALUES (1,'quinn0519.github.io','Quinn0519','2022-06-01 00:00:00','2022-06-01 00:00:00',1);
/*!40000 ALTER TABLE `link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `menu_id` int NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(255) DEFAULT NULL COMMENT '名称',
  `menu_url` varchar(255) DEFAULT NULL COMMENT 'URL',
  `menu_level` int DEFAULT NULL COMMENT '等级',
  `menu_icon` varchar(255) DEFAULT NULL COMMENT '图标',
  `menu_order` int DEFAULT NULL COMMENT '排序值',
  PRIMARY KEY (`menu_id`),
  UNIQUE KEY `menu_name` (`menu_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'关于本站','/aboutSite',1,'fa fa-info',1);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `options`
--

DROP TABLE IF EXISTS `options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `options` (
  `option_id` int NOT NULL,
  `option_site_title` varchar(255) DEFAULT NULL,
  `option_site_descrption` varchar(255) DEFAULT NULL,
  `option_meta_descrption` varchar(255) DEFAULT NULL,
  `option_meta_keyword` varchar(255) DEFAULT NULL,
  `option_aboutsite_avatar` varchar(255) DEFAULT NULL,
  `option_aboutsite_title` varchar(255) DEFAULT NULL,
  `option_aboutsite_content` varchar(255) DEFAULT NULL,
  `option_aboutsite_wechat` varchar(255) DEFAULT NULL,
  `option_aboutsite_qq` varchar(255) DEFAULT NULL,
  `option_aboutsite_github` varchar(255) DEFAULT NULL,
  `option_aboutsite_weibo` varchar(255) DEFAULT NULL,
  `option_tongji` varchar(255) DEFAULT NULL,
  `option_status` int DEFAULT '1',
  PRIMARY KEY (`option_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `options`
--

LOCK TABLES `options` WRITE;
/*!40000 ALTER TABLE `options` DISABLE KEYS */;
INSERT INTO `options` VALUES (1,'Quinn\'s Blog','为你我贡献经验 ','为你我贡献经验 ','Quinn\'s Blog','/img/logo.png','About','Quinn\'s blog为你我贡献经验 ','','','','',NULL,1);
/*!40000 ALTER TABLE `options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag` (
  `tag_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_name` varchar(50) DEFAULT NULL COMMENT '标签名',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `tag_name` (`tag_name`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (44,'DirectX'),(47,'NAND'),(45,'Windows'),(46,'WSL'),(48,'存储'),(43,'计算机图形学');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(30) NOT NULL DEFAULT '' COMMENT '用户名',
  `user_pass` varchar(100) NOT NULL DEFAULT '' COMMENT '密码',
  `user_nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '昵称',
  `user_email` varchar(100) DEFAULT '' COMMENT '邮箱',
  `user_url` varchar(100) DEFAULT '' COMMENT '个人主页',
  `user_avatar` varchar(100) DEFAULT NULL COMMENT '头像',
  `user_last_login_ip` varchar(30) DEFAULT NULL COMMENT '上传登录IP',
  `user_register_time` datetime DEFAULT NULL COMMENT '注册时间',
  `user_last_login_time` datetime DEFAULT NULL COMMENT '上传登录时间',
  `user_status` int unsigned DEFAULT '1' COMMENT '状态',
  `user_role` varchar(20) NOT NULL DEFAULT 'user' COMMENT '角色',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`),
  UNIQUE KEY `user_email` (`user_email`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','123456','管理员账户','admin@blog.com',NULL,'/img/avatar/avatar1.jpg','0:0:0:0:0:0:0:1','2022-05-31 00:00:00','2022-06-02 02:13:05',1,'admin'),(2,'user','123456','普通账户','user@blog.com',NULL,'/img/avatar/avatar.png','0:0:0:0:0:0:0:1','2022-05-31 00:00:00','2022-05-31 00:00:00',1,'user');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'quinns_blog'
--

--
-- Dumping routines for database 'quinns_blog'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-02 10:14:34
