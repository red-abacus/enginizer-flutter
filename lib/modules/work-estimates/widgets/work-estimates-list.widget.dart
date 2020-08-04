import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/custom-text-field-duration.dart';
import 'package:app/modules/shared/widgets/datepicker.widget.dart';
import 'package:app/modules/shared/widgets/single-select-dialog.widget.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimates/enums/work-estimate-sort.enum.dart';
import 'package:app/modules/work-estimates/models/work-estimate.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'cards/work-estimate-card.widget.dart';

class WorkEstimatesListWidget extends StatelessWidget {
  final List<WorkEstimate> workEstimates;

  Function filterWorkEstimates;
  Function selectWorkEstimate;

  final String searchString;
  final DateTime startDate;
  final DateTime endDate;
  final WorkEstimateStatus workEstimateStatus;
  final WorkEstimateSort workEstimateSort;

  final bool shouldDownload;
  final Function downloadNextPage;

  WorkEstimatesListWidget(
      {this.workEstimates,
      this.filterWorkEstimates,
      this.selectWorkEstimate,
      this.searchString,
      this.workEstimateStatus,
      this.startDate,
      this.endDate,
      this.workEstimateSort,
      this.shouldDownload,
      this.downloadNextPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildSearchBar(context),
            _buildFilterWidget(context),
            _buildDateWidget(context),
            _buildList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      child: CustomDebouncerTextField(
        currentValue: this.searchString,
        labelText: S.of(context).work_estimate_search_title,
        listener: (val) {},
      ),
    );
  }

  _buildDateWidget(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 5),
              child: BasicDateField(
                  dateTime: this.startDate,
                  maxDate: this.endDate != null ? this.endDate : null,
                  labelText: S.of(context).general_start_date,
                  onChange: (value) {
                    this.filterWorkEstimates(this.searchString, this.workEstimateStatus, this.workEstimateSort, value, this.endDate);
                  }),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: BasicDateField(
                  dateTime: this.endDate,
                  minDate: this.startDate != null ? this.startDate : null,
                  labelText: S.of(context).general_end_date,
                  onChange: (value) {
                    this.filterWorkEstimates(this.searchString, this.workEstimateStatus, this.workEstimateSort, this.startDate, value);
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 0.5, color: gray),
                ),
                height: 40,
                child: _statusText(context),
              ),
              onTap: () => _showStatusPicker(
                (context),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 0.5, color: gray),
                ),
                height: 40,
                child: _sortText(context),
              ),
              onTap: () => _showSortPicker(
                (context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusText(BuildContext context) {
    String title = (this.workEstimateStatus == null)
        ? S.of(context).work_estimate_sort_status
        : WorkEstimateStatusUtils.title(context, workEstimateStatus);

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            'assets/images/icons/filter.svg'.toLowerCase(),
            color: red,
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 2),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextHelper.customTextStyle(color: gray3, size: 16),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemBuilder: (ctx, index) {
          if (shouldDownload) {
            if (index == this.workEstimates.length - 1) {
              this.downloadNextPage();
            }
          }

          return WorkEstimateCard(
              workEstimate: workEstimates[index],
              selectWorkEstimate: _selectWorkEstimate);
        },
        itemCount: workEstimates.length,
      ),
    );
  }

  _selectWorkEstimate(WorkEstimate workEstimate) {
    this.selectWorkEstimate(workEstimate);
  }

  _sortText(BuildContext context) {
    String title = (this.workEstimateSort == null)
        ? S.of(context).work_estimate_sort_title
        : WorkEstimateSortUtils.title(context, workEstimateSort);

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            'assets/images/icons/filter.svg'.toLowerCase(),
            color: red,
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 2),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextHelper.customTextStyle(color: gray3, size: 16),
            ),
          ),
        )
      ],
    );
  }

  _showSortPicker(BuildContext context) async {
    List<SingleSelectDialogItem<WorkEstimateSort>> items = [];

    WorkEstimateSortUtils.list().forEach((sort) {
      items.add(SingleSelectDialogItem(
          sort, WorkEstimateSortUtils.title(context, sort)));
    });

    WorkEstimateSort sort = await showDialog<WorkEstimateSort>(
      context: context,
      builder: (BuildContext context) {
        return SingleSelectDialog(
          items: items,
          initialSelectedValue: this.workEstimateSort,
          title: S.of(context).invoice_sort_title,
        );
      },
    );

    this.filterWorkEstimates(this.searchString, this.workEstimateStatus, sort, this.startDate, this.endDate);
  }

  _showStatusPicker(BuildContext context) async {
    List<SingleSelectDialogItem<WorkEstimateStatus>> items = [];

    WorkEstimateStatusUtils.list().forEach((status) {
      items.add(SingleSelectDialogItem(
          status, WorkEstimateStatusUtils.title(context, status)));
    });

    WorkEstimateStatus status = await showDialog<WorkEstimateStatus>(
      context: context,
      builder: (BuildContext context) {
        return SingleSelectDialog(
          items: items,
          initialSelectedValue: this.workEstimateStatus,
          title: S.of(context).work_estimate_sort_status,
        );
      },
    );

    this.filterWorkEstimates(this.searchString, status, this.workEstimateSort, this.startDate, this.endDate);
  }
}
