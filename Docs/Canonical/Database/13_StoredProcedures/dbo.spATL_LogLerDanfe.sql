SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spATL_LogLerDanfe --'2015-09-01', '2015-09-30'
(
@Dt_Inicial datetime,
@Dt_Final datetime

)
as
Declare @Temp Table(
[BDP Ref.] varchar(16),
[Arquivo] varchar(300),
[Processado] datetime,
[Origem] varchar(50)

)


insert @Temp
select left(RIGHT(Arquivo,20),16) [BDP Ref.], Arquivo, DataIns [Processado], 'Pibernat' from Atlantis.dbo.LOG_Pibernat
where Status = 'Arquivo de NFe - Movido' and DataIns between @Dt_Inicial and @Dt_Final


insert @Temp
select Num_Proc , cNF + '_' + chNfe, dhRecbto, 'BDP - CHB' from ATL_BR.dbo.Danfe_Base
where Num_Proc like '%CSR%' and dhRecbto between @Dt_Inicial and @Dt_Final

select * from @Temp order by Origem,Processado
GO
