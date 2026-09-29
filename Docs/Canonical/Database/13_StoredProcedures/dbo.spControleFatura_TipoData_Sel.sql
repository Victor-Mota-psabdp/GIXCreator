SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spControleFatura_TipoData_Sel]--'','esp'
	@Num_Controle	Varchar(10),
	@idioma		varchar(3)
AS

select  ID_Tipo_Data [ID],
		(case @idioma 
			when 'PTG' then L.Descr_PTG
			when 'ESP' then L.Descr_ESP
			when 'ING' then L.descr_ING end)[Description],
--		Descricao_Tp_Data Descricao,
		 '' [Date] 
		from  Tipo_data_Controle_fatura T
		join atl_labels l on T.id_labels = L.id
where Ativo='S'
GO
