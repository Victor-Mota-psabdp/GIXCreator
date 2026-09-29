SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BuscaProcessosTransf_Sel](
@CD_Import varchar(10), 
@CD_Consig varchar(10),
@CD_Export varchar(10),
@Grupo varchar(10)
)
as

select Num_Proc_HIM Num_Proc from  House_Imp_Mar HOU with(nolock)
join Pessoa_LLP PLLP with(nolock) on HOU.Cd_Consig_HIM = PLLP.Cd_Pes
join Grupo GP with(nolock) on PLLP.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
join LLP_Imp_Mar LLP with(nolock) on LLP.Num_Proc_Lim = HOU.Num_Proc_HIM
where Cd_Import_HIM =@CD_Import and Cd_Consig_HIM =@CD_Consig and Cd_Export_HIM = @CD_Export and GP.Grupo = @Grupo and (ID_Status <> 9 or ID_Status is null)
union all
select Num_Proc_HIa Num_Proc from  House_Imp_Aer HOU with(nolock)
join Pessoa_LLP PLLP with(nolock) on HOU.Cd_Consig_HIa = PLLP.Cd_Pes
join Grupo GP with(nolock) on PLLP.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
join LLP_Imp_Aer LLP with(nolock) on LLP.Num_Proc_Lia = HOU.Num_Proc_HIa
where Cd_Import_HIa =@CD_Import and Cd_Consig_HIa =@CD_Consig and Cd_Export_HIa = @CD_Export and GP.Grupo = @Grupo and (ID_Status <> 9 or ID_Status is null)
order by Num_Proc
GO
