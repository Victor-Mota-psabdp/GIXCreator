SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_DadosProcesso_Sel 'IMLVS201410008BR'
--strNum_Proc = "System.Windows.Forms.TextBox, Text: IMLVS201410008BR"
CREATE procedure [dbo].[spATL_DadosProcesso_Sel](
 @Num_Proc as varchar(16)
)
as

select Num_proc_Him Num_Proc,Cd_Import_HIM CD_Import,Cd_Consig_HIM CD_Consig,Cd_Export_HIM CD_Export, GP.Grupo from House_Imp_Mar HOU with(nolock)
join Pessoa_LLP PLLP with(nolock) on HOU.Cd_Consig_HIM = PLLP.Cd_Pes
join Grupo GP with(nolock) on PLLP.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
where Num_Proc_HIM = @Num_Proc

union 

select Num_proc_Hia Num_Proc,Cd_Import_HIa CD_Import,Cd_Consig_HIa CD_Consig,Cd_Export_HIa CD_Export, GP.Grupo from House_Imp_Aer HOU with(nolock)
join Pessoa_LLP PLLP with(nolock) on HOU.Cd_Consig_HIa = PLLP.Cd_Pes
join Grupo GP with(nolock) on PLLP.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
where Num_Proc_HIa = @Num_Proc
--where Num_Proc_HIM = 'IMLVS201410008BR'

GO
