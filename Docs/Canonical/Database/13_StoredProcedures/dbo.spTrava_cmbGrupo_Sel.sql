SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spTrava_cmbGrupo_Sel]
(
	@cd_pes varchar(20), @cd_usuario varchar(20)
)
AS

declare @cd_Pes_ax as varchar(6)
set @cd_Pes_ax = (select Top 1 Cd_Pes from Pessoa_ATL_AX with(nolock) where Cd_Pes = @cd_pes)

	select top 1 HSGProcesso from Hist_Geral_Sistema with(nolock)
	where substring(HSGProcesso,3,3) = 
		(select grupo from pessoa_llp PL with(nolock) 
			left join grupo G with(nolock) on G.cd_pes_grupo = PL.cd_pes_grupo 
			join Pessoa P with(nolock) on P.Cd_Pes = @cd_Pes_ax where PL.cd_pes = @cd_pes)
	and (select grupo from usuario with(nolock) where cd_usuario = @cd_usuario) <> 'ADMIN'


/*Antiga trava
select top 1 HSGProcesso from Hist_Geral_Sistema with(nolock)
	where substring(HSGProcesso,3,3) = (select grupo from pessoa_llp PL with(nolock) left join grupo G with(nolock) on G.cd_pes_grupo = PL.cd_pes_grupo where cd_pes = @cd_pes)
	and (select grupo from usuario with(nolock) where cd_usuario = @cd_usuario) <> 'ADMIN'


*/
GO
