SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spEnvelope
		@processo	varchar(16)
as
select 
	Nome_Raz_soc,RE_DSE_HEA,mawb_mea,hawb_hea,'BDP SOUTH AMERICA LTDA' BDP 
from
	house_exp_aer hou
	Join Pessoa pp on pp.cd_pes=cd_export_hea
	Join Master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea

where 
	num_proc_hea=@processo

GO
