SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spCamposAdicionaisPessoa_Sel] --'IMWAL20090114901'
(
@Cd_Pes varchar(16)
)
as

	select 
		Descr_Campo, isnull(Campo_Dados,'') Campo_Dados, Tab_Relacionada, Cod_Busca, Campo_Exibicao 
	from tipo_campo_pessoa TCC
		left join Campo_Pessoa CP on TCC.Id_Campo=CP.Id_Campo and Cd_Pes=@Cd_Pes 
	where
		TCC.Tipo <> 'X' and (cd_pes_grupo = @cd_pes or cd_pes_grupo = '10017')
	order by
		Descr_Campo





GO
