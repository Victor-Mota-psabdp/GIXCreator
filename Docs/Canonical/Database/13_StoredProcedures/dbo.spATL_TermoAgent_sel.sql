SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spATL_TermoAgent_sel 'IMVIX201510005'
CREATE procedure  [dbo].[spATL_TermoAgent_sel]
(
@Num_Proc as varchar(16)
)
as
select TM.Empresa from vwHouse_Imp HOU 
join Armador ARM  with(nolock) on HOU.cd_Armador = ARM.cd_armador
join Termo_Container TM with(nolock) on ARM.cd_termo = TM.cd_termo
where HOU.Num_proc = @Num_Proc
union
select TM.Empresa from Master_Imp_Mar MAS 
join Armador ARM  with(nolock) on MAS.cd_Armador = ARM.cd_armador
join Termo_Container TM with(nolock) on ARM.cd_termo = TM.cd_termo
where MAS.Num_Proc_MIM = @Num_Proc
GO
