SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_BuscaTemplate_Sel '078','8'
CREATE procedure spATL_BuscaTemplate_Sel
(
@Cd_Tela varchar(3),
@ID_Template bigint
)
as
select Template_File from Tela_Template TE with(nolock)
left join Type_Template TY with(nolock) on TE.ID_Template = TY.ID
where TE.cd_tela = @Cd_Tela and  ID_Screen_Template = @ID_Template

GO
