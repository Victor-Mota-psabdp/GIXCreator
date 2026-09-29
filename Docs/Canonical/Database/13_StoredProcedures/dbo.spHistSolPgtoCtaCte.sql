SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spHistSolPgtoCtaCte](
		@HSGID	bigint,
		@Nome_Tp_Ocor	varchar(50),
		@HSGDescr	varchar(500),
		@Cd_Usuario	varchar(6),
		@Disp_Cliente	bit,
		@HSGDataPrev datetime
)
as
Declare @HSGSeq int
Declare @Cd_Tp_Ocor int
set @Cd_Tp_Ocor = (Select Cd_Tp_Ocor from tipo_ocorrencia with(nolock) where Nome_Tp_Ocor = @Nome_Tp_Ocor)
set @HSGSeq = (Select isnull(MAX(HSGSeq)+1,1) from Hist_Sol_Pgto_Cta_Cte where HSGID = @HSGID)
Insert into Hist_Sol_Pgto_Cta_Cte(
				HSGID,
				HSGSeq,
				Cd_Tp_Ocor,
				HSGDescr,
				HSGData,
				Cd_Usuario,
				Disp_Cliente,
				HSGDataPrev
				)
				values(
					@HSGID,
					@HSGSeq,
					@Cd_Tp_Ocor,
					@HSGDescr,
					GETDATE(),
					@Cd_Usuario,
					@Disp_Cliente,
					@HSGDataPrev
				)

	
GO
