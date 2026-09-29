SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spTipoCampoPessoa_Delete_Sel 'Account Manager', 'BDP (SÃO PAULO)'

CREATE procedure [dbo].[spTipoCampoPessoa_Delete_Sel] --'Grupo MARS'
(
	@Descr_Campo varchar(50),
	@Grupo varchar(20)
)
as

select CP.cd_pes, CP.id_campo, TCC.cd_pes_grupo, apelido
	from Tipo_campo_pessoa TCC 
join Campo_Pessoa CP on TCC.Id_Campo=CP.Id_Campo 
left join Grupo G on G.Cd_pes_grupo=TCC.cd_pes_grupo 
left join pessoa P on P.cd_pes=TCC.cd_pes_grupo  
where 
Descr_Campo=@Descr_Campo
and apelido=@Grupo













GO
